require "test_helper"

describe ProductsController do

##########LOGGED IN MERCHANT#################
  describe "logged in merchant" do
    before do
      merchant = Merchant.first
      login(merchant)
    end

    describe "root" do
      it "returns a success status" do
        get root_path
        must_respond_with :success
      end
    end

    describe "index" do
      it "shows all products" do
        get products_path
        must_respond_with :success
      end

      it "returns success status when there are no products" do
        Product.destroy_all
        get products_path
        must_respond_with :success
      end
    end

    describe "show" do
      it "returns success when given a valid product id" do
        product_id = Product.first.id
        # user_id = session[:user_id]
        get product_path(product_id)
        must_respond_with :success
      end

      it "returns not_found when given a bad work id" do
        bad_product_id = Product.last.id + 1
        get product_path(bad_product_id)
        must_respond_with :not_found
      end
    end

    describe "new" do
      it "creates a new product successfully" do
        get new_product_path
        must_respond_with :success
      end
    end

    describe "create" do
      it "saves and redirects to products_path when the product data is valid" do
        product_data = {
          product: {
            name: "book",
            price: 4.32,
            inventory: 2,
            category_ids: [categories(:book).id]
          }
        }
        product = Product.new(product_data[:product])
        product.merchant_id = session[:merchant_id]
        product.must_be :valid?
        start_product_count = Product.count

        post products_path, params: product_data
        must_respond_with :redirect
        must_redirect_to products_path(product.id)
        Product.count.must_equal start_product_count + 1
      end

      it "renders a bad_request when the product data is invalid" do
        bad_product = {
          product: {
            name: "book",
            # no price given!!
          }
        }
        Product.new(bad_product[:product]).wont_be :valid?
        start_product_count = Product.count
        post products_path, params: bad_product

        must_respond_with :bad_request
        Product.count.must_equal start_product_count
      end
    end

    describe "edit" do
      it "returns success when given a valid product id" do
        product_id = Product.first.id
        get product_path(product_id)
        must_respond_with :success
      end

      it "returns not_found when given a bad work id" do
        bad_product_id = Product.last.id + 1
        get product_path(bad_product_id)
        must_respond_with :not_found
      end
    end

    describe "update" do
      it "returns success when change is valid" do
        product = Product.first
        product_data = {
          product: {
            name: "book",
            price: 4.32,
            category_ids: Category.first.id
          }
        }
        product.update_attributes(product_data[:product])
        product.must_be :valid?

        patch product_path(product), params: product_data
        must_respond_with :redirect
        must_redirect_to product_path(product)

        product.reload
        product.name.must_equal product_data[:product][:name]
      end

      it "returns not_found if product id is invalid" do
        bad_product_id = Product.last.id + 1
        product_data = {
          product: {
            name: " title"
          }
        }
        patch product_path(bad_product_id), params: product_data
        must_respond_with :not_found
      end

      it "returns bad_request when change is invalid" do
        product = Product.first
        bad_product_data = {
          product: {
            name: ""
          }
        }
        product.update_attributes(bad_product_data[:product])
        product.wont_be :valid?
        start_product_count = Product.count

        patch product_path(product), params: bad_product_data
        must_respond_with :bad_request
        Product.count.must_equal start_product_count
      end
    end

    describe "destroy" do
      it "returns success when product is deleted" do
        product_count = Product.count
        product_id = Product.first
        delete product_path(product_id)
        must_respond_with :redirect
        must_redirect_to products_path
        Product.count.must_equal product_count - 1
      end

      it "returns not_found if given invalid product id" do
        bad_product_id = Product.last.id + 1

        delete product_path(bad_product_id)
        must_respond_with :not_found
      end
    end
  end

##########NOT LOGGED IN USERS#################
  describe "not logged in users" do
    describe "root" do
      it "returns a success status" do
        get root_path
        must_respond_with :success
      end
    end

    describe "index" do
      it "shows all products" do
        get products_path
        must_respond_with :success
      end

      it "returns success status when there are no products" do
        Product.destroy_all
        get products_path
        must_respond_with :success
      end
    end

    describe "show" do
      it "returns success when given a valid product id" do
        product_id = Product.first.id
        # user_id = session[:user_id]
        get product_path(product_id)
        must_respond_with :success
      end

      it "returns not_found when given a bad work id" do
        bad_product_id = Product.last.id + 1
        get product_path(bad_product_id)
        must_respond_with :not_found
      end
    end

    describe "new" do
      it "will set flash[:status] to failure and redirect to products_path" do
        get new_product_path
        flash[:status].must_equal :failure
        must_respond_with :redirect
        must_redirect_to products_path
      end
    end

    describe "edit" do
      it "will set flash[:status] to failure and redirect to products_path" do
        product_id = Product.first.id
        get edit_product_path(product_id)
        flash[:status].must_equal :failure
        flash[:message].must_equal "You must be logged in to do that!"
        must_respond_with :redirect
        must_redirect_to products_path
      end
    end

    describe "destroy" do
      it "will set flash[:status] to failure and redirect to products_path" do
        delete product_path(Product.first)
        flash[:status].must_equal :failure
        must_respond_with :redirect
        must_redirect_to products_path
      end
    end

    #Do we need tests for #create and #update here?
  end
end
