require "test_helper"

describe PaymentInfo do
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

end
