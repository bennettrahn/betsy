require "test_helper"

describe Order do
  let (:order) { orders(:order1) }
  describe "relationships" do
    it "has a list of order_products, which have products." do
      order.must_respond_to :order_products
      order.order_products.each do |op|
        op.product.must_be_kind_of Product
      end
    end
  end

  describe "methods" do
    describe "products" do
      it "returns an array of products for that order" do
        order.products.each do |product|
          product.must_be_kind_of Product
        end
      end

      it "returns an empty array if the order has no products" do
        empty_order = Order.new
        empty_order.products.must_be_empty
      end
    end
  end
end
