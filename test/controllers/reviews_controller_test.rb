require "test_helper"

describe ReviewsController do
  # let (:review) {reviews(:review1)}

  describe "new" do
    it "creates a new review successfully" do
      @product = Product.first.id
      get new_product_review_path(@product)
      must_respond_with :success
    end
  end

  describe "create" do
    #  BOTH create tests need :product_id! HOW DO WE PASS IN?

    it "saves and redirects to product show page when the review data is valid" do
      product =  Product.first
     review_data = {
       review: {
         rating: 3,
         text: "I loved it!",
         product_id: product.id
       }
     }
     product.reviews.new(review_data[:review]).must_be :valid?
     start_review_count = Review.count

     post reviews_path, params: review_data

     must_respond_with :redirect
     must_redirect_to product_path(product.id)
     Review.count.must_equal start_review_count + 1
   end


    # it "renders a bad_request when the review data is invalid" do
    #   product =  Product.first
    #   bad_review = {
    #     review: {
    #       rating: "",
    #       product_id: product.id
    #       # no rating given!!
    #     }
    #   }
    #   product.reviews.new(bad_review[:review]).wont_be :valid?
    #
    #   start_review_count = Review.count
    #   post reviews_path, params: bad_review
    #
    #   must_respond_with :bad_request
    #
    #   Review.count.must_equal start_review_count
    # end
    # need to write test for when create is not allowed (not merchant_id)
  end



end
