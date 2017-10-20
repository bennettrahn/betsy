require "test_helper"

describe OrderProductsController do
  describe "create" do
    it "creates an OrderProduct with a product and an order, creates a new order if no session[:cart] exists" do
      product_params = {
        product_id: products(:tricycle).id,
        quantity: 1
      }
      orders_start = Order.count
      start_count = OrderProduct.count
      inventory = products(:tricycle).inventory

      post create_order_product_path, params: product_params
      must_redirect_to order_path(session[:cart])

      OrderProduct.count.must_equal start_count + 1
      Order.count.must_equal orders_start + 1
      products(:tricycle).inventory.must_equal inventory - 1
    end

    it "creates an OrderProduct with a product and an order, adds to existin cart if it has already been initiated" do
      product_params = {
        product_id: products(:tricycle).id,
        quantity: 1
      }
      post create_order_product_path, params: product_params
      #I have to do this in order to set session.

      orders_start = Order.count
      start_count = OrderProduct.count

      post create_order_product_path, params: product_params
      must_redirect_to order_path(session[:cart])

      OrderProduct.count.must_equal start_count + 1
      Order.count.must_equal orders_start
    end

    it "wont create if input is invalid" do
      product_params = {
        product_id: products(:tricycle).id,
        quantity: 0
      }
      start_count = OrderProduct.count

      post create_order_product_path, params: product_params
      must_respond_with :bad_request

      OrderProduct.count.must_equal start_count
    end

  end
end
