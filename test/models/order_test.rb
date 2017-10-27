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
      order_products(:four)
      order = orders(:order1)

      order.order_complete?.must_equal false
    end

    #TODO: what if there are no orderproducts?
    # it "sets flash[:status] to failure is there are no orderproducts" do
    #   OrderProducts.destroy_all
    #   order = orders(:order1)
    #
    #   order.order_complete?.
    # end

  end

  describe "order_total" do
    it "returns the total of the whole order if no merchant is passed" do
      orders(:order4).order_total.must_equal products(:tripod).price + products(:tricycle).price
    end

    it "returns the total of the products belonging to a merchant if one is passed" do
      orders(:order4).order_total(merchant: merchants(:lauren)).must_equal products(:tripod).price
    end

    it "returns 0 when there are no products" do
      orders(:order4).order_total(merchant: merchants(:bennett)).must_equal 0

      orders(:order6).order_total.must_equal 0
    end
  end
end
