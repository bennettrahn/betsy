require "test_helper"

describe Product do

  before do
    @p = Product.new
  end

  describe "relations" do
    it "must respond to merchant" do
      @p.must_respond_to :merchant
    end

    it "can have order_products" do
      @p.must_respond_to :order_products
    end

  end

  describe 'validations' do
    it 'is valid' do
      b = Product.new(name: "book", price: 2,   merchant_id: Product.first.merchant_id)
      b.must_be :valid?
    end

    it 'requires a name' do
      is_valid = @p.valid?
      is_valid.must_equal false
      @p.errors.messages.must_include :name
    end

    it 'requires a unique name' do
      name = "test book"
      b1 = Product.create!(name: name, price: 1,   merchant_id: Product.first.merchant_id)
      b2 = Product.new(name: name, price: 2,   merchant_id: Product.first.merchant_id)
      b2.wont_be :valid?
    end

    it 'requires a price' do
      is_valid = @p.valid?
      is_valid.must_equal false
      @p.errors.messages.must_include :price
    end

    it 'requires a price greater than 0' do
      b = Product.new(name: name, price: -1)
      is_valid = b.valid?
      is_valid.must_equal false
      b.errors.messages.must_include :price
    end
  end

  describe "decrease_inventory" do
    let(:tricycle) { products(:tricycle) }
    it "decreases the inventory by the given quantity" do
      start = tricycle.inventory

      tricycle.decrease_inventory(1)

      tricycle.inventory.must_equal start - 1
    end
  end

  describe "decrease_inventory" do
    let(:tripod) { products(:tripod) }
    it "decreases the inventory by the given quantity" do
      max = tripod.inventory

      tripod.check_inventory(max).must_equal true

      tripod.check_inventory(max - 1).must_equal true

      tripod.check_inventory(max + 1).must_equal false
    end

    it "returns false if the inventory is 0" do
      tripod.inventory = 0

      tripod.check_inventory(1).must_equal false
    end
    #since quantity has been validated to be always more than 0, do I still need to check other edge cases?

  describe "#average_rating" do
    it "returns an Integer that is the average of all ratings" do
      #arrange

      product = Product.first

      review = Review.create!(rating: 5, product_id: product.id)
      review_2 = Review.create!(rating: 3, product_id: product.id)
      review_3 = Review.create!(rating: 1, product_id: product.id)

      all_reviews_product_1 = [review, review_2, review_3]
      sum_rating = 0
      review_count = 0
      all_reviews_product_1.each do |review|
        sum_rating += review.rating
        review_count += 1
      end

      ave_rating = sum_rating / review_count

      #act
      #assert
      product.average_rating.must_equal ave_rating
    end

    it "returns 0 if no reviews" do
      product = Product.first

      product.average_rating.must_equal 0
    end
  end

end
