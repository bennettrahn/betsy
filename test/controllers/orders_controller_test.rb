require "test_helper"

describe OrdersController do
  let :order_data {
    order_data = {
      order: {
        status: "pending",
        buyer_name: "Zachary"
      }
    }
  }
  let :order_id { Order.last.id }


  describe "index" do
    it "returns a success status for all orders" do
      get orders_path
      must_respond_with :success
    end

    it "returns a success status for no orders" do
      Order.destroy_all
      get orders_path
      must_respond_with :success
    end
  end




  describe "show" do
    it "returns success when given a vaild id" do
      get order_path(order_id)
      must_respond_with :success
    end
    it "returns not_found when given an invaild id" do
      get order_path(order_id + 1)
      must_respond_with :not_found
    end

  end


  describe "update" do
    it "returns not_found when given an invaild id" do
      put order_path(order_id + 1), params: order_data
      must_respond_with :not_found
    end

    it "returns succes if the order exists and the change is valid" do

      orders(:order1).must_be :valid?
      put order_path(orders(:order1)), params: order_data
      must_respond_with :redirect
      must_redirect_to order_path(orders(:order1))
    end


    # it "returns bad_request if the change is invalid" do
    #   #  don't quite know how to check invalidity here....
    #   put order_path(orders(:order1)), params: invalid_order_data
    #   must_respond_with :bad_request
    # end
  end

  describe "destroy" do
    it "returns success if the order was destroyed" do
      total = Order.count
      delete order_path(orders(:order1))
      must_respond_with :redirect
      must_redirect_to orders_path
      total.must_equal Order.count + 1
    end

    it "returns not_found when given an invaild id" do
      put order_path(order_id + 1)
      must_respond_with :not_found
    end

  end
end
