require "test_helper"

describe Category do

  let (:category) {categories(:book)}

  describe "relations" do
    it "must be connected to products" do
      category.must_respond_to :products
    end
  end

  describe "validations" do
    it "is valid when given valid category data" do
      new_cat = Category.new(name: "record")
      new_cat.must_be :valid?
    end

    it "requires a name" do
      invalid_cat = Category.new(name: "")
      invalid_cat.wont_be :valid?
    end

    it "requres a name that is unique" do
      new_cat = Category.new(name: "record")
      new_cat.save
      new_cat_2 = Category.new(name: "record")
      new_cat_2.wont_be :valid?
    end
  end

  describe "#self.spot" do
    it "can be called" do
      Category.must_respond_to :spot
    end

    it "returns a Product object" do
      Category.spot.must_be_instance_of Product
    end

    it "returns nil if no products" do
      Product.destroy_all
      Category.spot.must_equal nil
    end
  end

  describe "#self.root_page_seasonal_pick" do
    it "can be called" do
      Category.must_respond_to :root_page_seasonal_pick
    end

    it "returns an array of Product objects" do
      halloween_category = Category.new(name: "Halloween")
      product = products(:tricycle)
      product.category_ids << halloween_category.id

      array_products = Category.root_page_seasonal_pick
      array_products.must_be_instance_of Array
      array_products[0].must_be_instance_of Product
    end

    it "returns an empty array of if no products" do
      Product.destroy_all
      Category.root_page_seasonal_pick.must_be :empty?
    end

    it "returns an empty array if no categories" do
      Category.destroy_all
      Category.root_page_seasonal_pick.must_be :empty?
    end
  end

end
