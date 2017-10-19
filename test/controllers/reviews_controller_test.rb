require "test_helper"

describe ReviewsController do
  # it "must be a real test" do
  #   flunk "Need real tests"
  # end

  before do
    @review = Review.new
  end

  describe "relations" do
    it "must respond to product" do
      @review.must_respond_to :product
    end
  end
  describe 'validations' do
    it 'is valid' do
      review = Review.new(rating: 3, product_id: Product.first.id)
      review.must_be :valid?
    end

    it 'requires a rating' do
      is_valid = @review.valid?
      is_valid.must_equal false
      @review.errors.messages.must_include :rating
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
