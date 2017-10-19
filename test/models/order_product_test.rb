require "test_helper"

describe OrderProduct do
  let (:op) { order_products(:one) }
  describe "relationships" do
    it "has an order" do
      op.must_respond_to :order
      op.order.must_be_kind_of Order
    end

    it "has a product" do
      op.must_respond_to :product
      op.product.must_be_kind_of Product
    end
  end
end
