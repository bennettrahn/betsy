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
end
