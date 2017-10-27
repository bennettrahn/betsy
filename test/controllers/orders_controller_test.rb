require "test_helper"

describe OrdersController do
  let :order_data {
    order_data = {
      order: {
        status: "pending",
        payment_info: payment_infos(:payment1)
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
    it "returns success when given the current cart id." do
      product_params = {
        product_id: products(:tricycle).id,
        quantity: 1
      }
      post create_order_product_path, params: product_params

      get order_path(session[:cart])
      must_respond_with :success
    end
    it "returns not_found when given an invaild id" do
      get order_path(order_id + 1)
      must_respond_with :not_found
    end
    it "wont show past orders" do
      get order_path(order_id)
      must_redirect_to root_path
    end
  end

  describe "update" do
    it "returns not_found when given an invaild id" do
      put order_path(order_id + 1), params: order_data
      must_respond_with :not_found
    end

# NEED TO FIX ##############
    it "returns success if the order exists and the change is valid" do
      payment_data = {
        payment_info: {
          email: "example@example.com",
          buyer_name: "name",
          cvv: "123",
          card_number: "123456",
          zipcode: "12345",
          mailing_address: "12 34th st",
          expiration: "12/34"
        }

      }

      orders(:order1).must_be :valid?
      get checkout_path(orders(:order1))
      put order_path(orders(:order1)), params: payment_data
      session[:cart].must_be_nil
      must_respond_with :redirect
      must_redirect_to order_receipt_path(orders(:order1))
    end
  end

  describe "checkout" do
    it "sends the user to the checkout form" do
      get checkout_path(order_id)
      must_respond_with :success
    end
    it "not valid when order doesn't exist" do
      get checkout_path(order_id + 1)
      must_respond_with :not_found
    end
  end

  describe "receipt" do
    it "shows the receipt after a successful update/checkout" do
      merchant = merchants(:anders)
      login(merchant)
      payment_data = {
        payment_info: {
          email: "example@example.com",
          buyer_name: "name",
          cvv: "123",
          card_number: "123456",
          zipcode: "12345",
          mailing_address: "12 34th st",
          expiration: "12/34"
        }

      }
      patch order_path(orders(:order1)), params: payment_data

      get order_receipt_path(orders(:order1))
      must_respond_with :success
    end

    it "cannot see a receipt twice; receipts will only show immediately after a purchase" do

      payment_data = {
        payment_info: {
          email: "example@example.com",
          buyer_name: "name",
          cvv: "123",
          card_number: "123456",
          zipcode: "12345",
          mailing_address: "12 34th st",
          expiration: "12/34"
        }
      }
      patch order_path(orders(:order1)), params: payment_data

      get order_receipt_path(orders(:order1))
      must_respond_with :success

      get order_receipt_path(orders(:order1))
      must_respond_with :redirect
      flash[:status].must_equal :failure
    end

    it "shows the receipt to the merchant who is the owner of the orderproduct; so a merchant can see a receipt twice" do
      merchant = merchants(:anders)
      login(merchant)

      payment_data = {
        payment_info: {
          email: "example@example.com",
          buyer_name: "name",
          cvv: "123",
          card_number: "123456",
          zipcode: "12345",
          mailing_address: "12 34th st",
          expiration: "12/34"
        }
      }
      patch order_path(orders(:order1)), params: payment_data

      get order_receipt_path(orders(:order1))
      must_respond_with :success

      get order_receipt_path(orders(:order1))
      must_respond_with :success
    end
  end

  describe "destroy" do
    it "returns success if the order was destroyed" do
      total = Order.count
      delete order_path(orders(:order1))
      must_respond_with :redirect
      must_redirect_to root_path
      total.must_equal Order.count + 1
    end

    it "returns not_found when given an invaild id" do
      put order_path(order_id + 1)
      must_respond_with :not_found
    end

  end
end
