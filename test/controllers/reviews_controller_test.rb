require "test_helper"

describe ReviewsController do
  # let (:review) {reviews(:review1)}

  #######LOGGED IN MERCHANT##########
  describe "logged in merchant" do
    before do
      merchant = Merchant.first
      login(merchant)
    end

    describe "new" do
      it "creates a new review successfully" do
        @product = Product.first.id
        get new_product_review_path(@product)
        must_respond_with :success
      end

      it "returns not_found if given invalid product id" do
        invalid_prod_id = Product.last.id + 1
        get new_product_review_path(invalid_prod_id)
        must_respond_with :not_found
      end
    end

    describe "create" do
      it "saves and redirects to product show page when the review data is valid" do

        product =  Product.first
        review_data = {
          review: {
          rating: 3,
          text: "I loved it!",
          product_id: product.id
          }
        }
        puts review_data[:review][:product_id]
        product.reviews.new(review_data[:review]).must_be :valid?
        start_review_count = Review.count

        post reviews_path, params: review_data

        must_respond_with :redirect
        must_redirect_to product_path(product.id)
        Review.count.must_equal start_review_count + 1
      end


    # it "renders a bad_request when the review data is invalid" do
      # what if the star is left blank...
      it "doesn't allow a merchant to review their own product" do
        merchant = merchants(:anders)
        login(merchant)
        product =  Product.find_by(merchant: merchant)
        # anders_review = {
        #   review: {
        #     rating: 1,
        #     product_id: product.id
        #   }
        # }
        # Review.new(anders_review[:review]).wont_be :valid?

        start_review_count = Review.count
        get new_product_review_path(product)

        must_redirect_to products_path
        flash[:message].must_equal "You cannot review your own product!"
        Review.count.must_equal start_review_count
      end
    end
    # need to write test for when create is not allowed (not merchant_id)
  end
end
