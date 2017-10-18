require "test_helper"

describe ProductsController do
  # it "must be a real test" do
  #   flunk "Need real tests"
  # end

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
    # need to write test for when new is not allowed (not merchant_id)
  end

  describe "create" do
    it "saves and redirects to products_path when the product data is valid" do
      product_data = {
        product: {
          name: "book",
          price: 1,
        }
      }
      Product.new(product_data[:product]).must_be :valid?
      start_product_count = Product.count

      post products_path, params: product_data
      must_respond_with :redirect
      must_redirect_to products_path
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
    # need to write test for when create is not allowed (not merchant_id)
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
    # need to write test for when edit is not allowed (not merchant_id)
  end

  describe "update" do
    it "returns success when change is valid" do
      product = Product.first
      product_data = {
        product: {
          name: "book",
          price: 4.32
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

    # need to write test for when update is not allowed (not merchant_id)
  end

  describe "destroy" do
    it "success when product is deleted" do
      product_count = Product.count
      delete product_path(Product.first)
      must_respond_with :redirect
      must_redirect_to products_path
      product_count.must_equal Product.count + 1
    end

    # need to write test for when destroy is not allowed (not merchant_id)
  end
end