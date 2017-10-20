require "test_helper"

describe Category do
  # let(:category) { Category.new }
  #
  # it "must be valid" do
  #   value(category).must_be :valid?
  # end
  let (:category) {categories(:book)}

  describe "relations" do
    it "must be connected to products" do
      category.must_respond_to :products
    end
  end
end


# unqiqueness and presence
