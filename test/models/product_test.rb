require "test_helper"

describe Product do

  before do
    @p = Product.new
  end

  describe "relations" do
    it "must respond to merchant" do
      @p.must_respond_to :merchant
    end

    it "has a merchant" do
      prod = products(:tricycle)
      merch = merchants(:anders)

      prod.merchant.must_equal merch
      prod.merchant_id.must_equal merch.id
    end

    it "can have order_products" do
      @p.must_respond_to :order_products

      prod = products(:tricycle)
      order = orders(:order1)
      order_prod = OrderProduct.create!(quantity: 1, product: prod, order: order)

      prod.order_products << order_prod

      prod.order_products.must_include order_prod
      # prod = products(:tricycle)
      # order_prod = order_products(:one)
      #
      # prod.order_products.must_equal order_prod
      # prod.order_products_ids.must_equal order_prod.id
    end

    #TODO: tried to work on this test. not understanding the through relationship well enough. Product doesn't have a direct relationship with Order, so how to connect them in tests?
    it "can have orders through order_products" do
      @p.must_respond_to :orders
      #
      # prod = products(:tricycle)
      # order = orders(:order2)
      # order_prod = OrderProduct.create!(quantity: 1, product: prod, order: order)
      #
      # prod.order_products.product_id.must_equal order.order_products.product_id
    end

    it "can have reviews" do
      @p.must_respond_to :reviews

      product = products(:tricycle)

      review = Review.create!(rating: 4, text: "great", product_id: product.id)
      product.reviews << review
      product.reviews.must_include review
    end

    it "has at least one category, and can have multiple" do
      @p.must_respond_to :categories

      @p.categories.must_be :empty?

      cat = Category.create!(name: "computers")
      @p.categories << cat
      @p.categories.must_include cat

      cat2 = Category.create!(name: "three-legged chairs")
      @p.categories << cat2
      @p.categories.must_include cat2
    end

  end

  describe 'validations' do
    it 'is valid' do
      b = Product.new(name: "book", price: 2, merchant_id: Product.first.merchant_id, inventory: Product.first.inventory)
      b.category_ids = Category.first.id
      b.must_be :valid?
    end

    it 'requires a name' do
      is_valid = @p.valid?
      is_valid.must_equal false
      @p.errors.messages.must_include :name
    end

    it 'requires a unique name' do
      name = "test book"
      Product.create!(name: name, price: 1, merchant_id: Product.first.merchant_id, inventory: Product.first.inventory, category_ids: Category.first.id)
      b2 = Product.new(name: name, price: 2, merchant_id: Product.first.merchant_id, inventory: Product.first.inventory, category_ids: Category.first.id)
      b2.wont_be :valid?
    end

    it 'requires a price' do
      is_valid = @p.valid?
      is_valid.must_equal false
      @p.errors.messages.must_include :price
    end

    it 'requires a price greater than 0' do
      b = Product.new(name: "tom petty video", price: -1)
      is_valid = b.valid?
      is_valid.must_equal false
      b.errors.messages.must_include :price
    end

    it "requires inventory that is greater or equal to 0" do
      p = Product.new(name: "tom petty video", price: 1)
      is_valid = p.valid?
      is_valid.must_equal false
      p.errors.messages.must_include :inventory

      p2 = Product.new(name: "tom petty video", price: 1, inventory: -1)
      is_valid = p2.valid?
      is_valid.must_equal false
      p2.errors.messages.must_include :inventory
    end

    it "requires the presence of a category" do
      p = Product.new(name: "tom petty video", price: 1, inventory: 1)
      is_valid = p.valid?
      is_valid.must_equal false
      p.errors.messages.must_include :category_ids
    end
  end

  #TODO:
  describe "increase_inventory" do


  end

  describe "decrease_inventory" do
    let(:tricycle) { products(:tricycle) }
    it "decreases the inventory by the given quantity" do
      start = tricycle.inventory

      tricycle.decrease_inventory(1)

      tricycle.inventory.must_equal start - 1
    end
  end

  describe "check_inventory" do
    let(:tripod) { products(:tripod) }
    it "returns true when there is inventory, and returns false when there isn't" do
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

  end

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
      Review.destroy_all
      product = Product.first

      product.average_rating.must_equal 0
    end
  end

end
