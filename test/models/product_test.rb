require "test_helper"

describe Product do
  # let(:product) { Product.new }
  #
  # it "must be valid" do
  #   value(product).must_be :valid?

  describe 'validations' do
    it 'is valid' do
      b = Product.new(name: "book", price: 2)
      b.must_be :valid?
    end

    it 'requires a name' do
      b = Product.new
      is_valid = b.valid?
      is_valid.must_equal false
      b.errors.messages.must_include :name
    end

    it 'requires a unique name' do
      name = "test book"
      b1 = Product.create!(name: name, price: 1)
      b2 = Product.new(name: name, price: 2)
      b2.wont_be :valid?
    end

    it 'requires a price' do
      b = Product.new
      is_valid = b.valid?
      is_valid.must_equal false
      b.errors.messages.must_include :price
    end

    it 'requires a price greater than 0' do
      b = Product.new(name: name, price: -1)
      is_valid = b.valid?
      is_valid.must_equal false
      b.errors.messages.must_include :price
    end

  end

  describe "relations" do

  end

end
