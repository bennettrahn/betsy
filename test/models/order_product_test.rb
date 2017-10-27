require "test_helper"

describe OrderProduct do
  let (:op) { order_products(:five) }
  let (:order) { orders(:order1) }
  let (:product) { products(:tricycle)}

  describe "relationships" do
    it "has an order" do
      op.must_respond_to :order
      op.order.must_be_kind_of Order
    end

    it "has a product" do
      op.must_respond_to :product
      op.product.must_be_kind_of Product
    end

    it "has a merchant" do
      op.must_respond_to :merchant
      op.merchant.must_be_kind_of Merchant
    end
  end

  describe "vaildations" do
    it "works with a number greater than 0" do
      [1, 3, 7, 10].each do |quantity|
        op_valid = OrderProduct.new(order: order, product: product, quantity: quantity)
        op_valid.valid?.must_equal true
      end
    end

    it "doesn't work with non-valid things." do
      [0, -7, "nil"].each do |quantity|
        op_invalid = OrderProduct.new(order: order, product: product, quantity: quantity)
        op_invalid.valid?.must_equal false
        op_invalid.errors.messages.must_include :quantity
      end

    end
  end
end
