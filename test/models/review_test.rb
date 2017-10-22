require "test_helper"

describe Review do
  # let(:review) { Review.new }
  #
  # it "must be valid" do
  #   value(review).must_be :valid?
  # end
  let (:review) {reviews(:review1)}
  # before do
  #   @review = Review.new
  # end

  describe "relations" do
    it "must respond to product" do
      prod = products(:tricycle)

      review.must_respond_to :product
      review.product_id.must_equal prod.id
      review.product.must_equal prod
    end

  end
  describe 'validations' do
    it 'is valid' do
      review = Review.new(rating: 3, product_id: Product.first.id)
      review.must_be :valid?
    end

    it 'requires a rating' do
      review.rating = nil
      is_valid = review.valid?
      is_valid.must_equal false
      review.errors.messages.must_include :rating
    end

    it 'requires a ranking greater than 0' do
      review = Review.new(rating: 0, product_id: 1)
      is_valid = review.valid?
      is_valid.must_equal false
      review.errors.messages.must_include :rating
    end

    it 'requires a ranking less than 5' do
      review = Review.new(rating: 6, product_id: 1)
      is_valid = review.valid?
      is_valid.must_equal false
      review.errors.messages.must_include :rating
    end
  end
end
