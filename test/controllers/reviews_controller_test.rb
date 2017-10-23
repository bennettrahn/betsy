require "test_helper"

describe ReviewsController do
  # let (:review) {reviews(:review1)}

  #######LOGGED IN MERCHANT##########
  describe "logged in merchant" do
    before do
      merchant = merchants(:anders)
      login(merchant)
    end

    describe "new" do
      it "merchants can go to a new review path for other products" do
        product = products(:tripod)
        get new_product_review_path(product)
        must_respond_with :success
      end

      it "doesn't allow a merchant to go to a new review on their own product" do

        product = products(:tricycle)
        start_review_count = Review.count
        get new_product_review_path(product)

        must_redirect_to products_path
        flash[:message].must_equal "You cannot review your own product!"
        Review.count.must_equal start_review_count
      end
    end

    describe "create" do
      it "just in case, doesn't allow a merchant create a review on their own product" do
        # TODO: come back to this test
        # review_data = {
        #   review: {
        #     rating: 3,
        #     text: "I loved it!",
        #     product_id: product.id
        #   }
        # }
        # product = products(:tricycle)
        # start_review_count = Review.count
        # post reviews_path, params: review_data
        #
        # must_redirect_to products_path
        # flash[:message].must_equal "You cannot review your own product!"
        # Review.count.must_equal start_review_count
      end

      it "does allow a merchant to review other products" do
        product = products(:tripod)
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

    end
  end

  #######NOT LOGGED IN USER##########
  describe "not logged in user" do

    describe "new" do
      it "responds with success when directed to the  new review path" do
        product = Product.first.id
        get new_product_review_path(product)
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

      it "sends :bad_request if data is invalid" do

        product =  Product.first
        review_data = {
          review: {
          rating: 0,
          text: "I loved it!",
          product_id: product.id
          }
        }
        puts review_data[:review][:product_id]
        product.reviews.new(review_data[:review]).wont_be :valid?
        start_review_count = Review.count

        post reviews_path, params: review_data
        must_respond_with :bad_request

        Review.count.must_equal start_review_count
      end
    end

  end
end
