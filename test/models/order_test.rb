require "test_helper"

describe Order do
  let (:order) { orders(:order1) }
  describe "relationships" do
    it "has a list of order_products, which have products." do
      order.must_respond_to :order_products
      order.must_respond_to :products
      order.order_products.each do |op|
        op.product.must_be_kind_of Product
      end
    end

    it "has one payment_info" do
      order.must_respond_to :payment_info
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

  describe "order_complete?" do
    it "can be called" do
      order = orders(:order3)
      order.must_respond_to :order_complete?
    end
    it "returns true if the all order product status is complete" do
      op = order_products(:four)
      order = orders(:order1)
      op.status = "complete"
      op.save

      order.order_complete?.must_equal true
    end

    it "returns false if the order is not complete" do
      order = orders(:order2)
      

      order.order_complete?.must_equal false
    end
  end
end
