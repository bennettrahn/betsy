require "test_helper"

describe CategoriesController do

  #everyone can view all categories
  describe "index" do
    it "returns a success status when there are categories" do
      Category.count.must_be :>, 0, "No categories in the test fixtures"
      get categories_path
      must_respond_with :success
    end

    it "returns a success status when there are no categories" do
      Category.destroy_all
      get categories_path
      must_respond_with :success
    end
  end

  describe "not logged in user" do
    describe "new" do
      it "returns a flash[:status] of failure, and redirects to products path" do
        get new_category_path
        flash[:status].must_equal :failure
        must_respond_with :redirect
        must_redirect_to products_path
      end
    end

    describe "create" do
      it "returns a flash[:status] of failure, and redirects to products path" do
        new_cat = {
          category: {
            name: "new cat"
          }
        }

        post categories_path, params: new_cat
        flash[:status].must_equal :failure
        must_respond_with :redirect
        must_redirect_to products_path
      end
    end
  end


  describe "merchant logged in" do

    before do
      merchant = Merchant.first
      login(merchant)
    end

    describe "new" do
      it "returns a success status" do
        get new_category_path
        must_respond_with :success
      end
    end

    describe "create" do
      it "creates a new category with valid data and redirects to products_path" do
        new_cat = {
          category: {
            name: "new cat"
          }
        }
        post categories_path, params: new_cat
        must_respond_with :redirect
        must_redirect_to products_path
      end
    end
  end
end
