require "test_helper"

describe OrderProductsController do

  before do
    @product_params = {
      product_id: products(:tricycle).id,
      quantity: 1
    }
  end

  describe "update_status" do
    it "if entire order is complete, sets flash[:status] to success when order is saved with specific message, redirects merchant show page, and sets the orderproduct status and orders status to complete" do
      #arrange
      order_prod = order_products(:two)

      #assert
      patch update_status_path(order_prod.id)

      #act
      order_prod.reload
      flash[:status].must_equal :success
      order_prod.status.must_equal "complete"
      order_prod.order.status.must_equal"complete"
      flash[:message].must_equal "Order has been completed and shipped to buyer"
    end

    it "if order status is not complete, it was set flash[:status] to success and message to 'order has been completed and shipped to buyer', and the order status will not be complete" do
      #arrange
      order_prod = order_products(:two)

      #assert
      patch update_status_path(order_prod.id)

      #act
      order_prod.reload
      flash[:status].must_equal :success
      order_prod.status.must_equal "complete"
      order_prod.order.status.must_equal "pending"
      flash[:message].must_equal "Product has been added to order, Order is waiting on other products before shipping."
    end
  end

  describe "destroy" do
    it "deletes the orderproduct and redirects to order_path if there are still other orderproducts in the cart" do
      order_prod = order_products(:two)
      order_prod_2 = order_products(:three)
      order = orders(:order4)

      puts "ORDER PROD: #{order_prod}"
      order = order_prod.order
      puts "order id: #{order}"

      puts "ORDER PROD ID: #{order_prod.id}"
      delete order_product_path(order_prod.id)

      must_respond_with :redirect
      must_redirect_to order_path(order)
    end

    it "deletes the orderproduct and redirects to order_empty_cart_path if no more orderproducts in the order" do
      order_prod = order_products(:four)
      order = order_prod.order.id

      delete order_product_path(order_prod)

      must_respond_with :redirect
      must_redirect_to order_empty_cart_path
    end
  end

  describe "create" do

    it "creates an OrderProduct with a product and an order, creates a new order if no session[:cart] exists" do
      orders_start = Order.count
      start_count = OrderProduct.count

      post create_order_product_path, params: @product_params
      must_redirect_to order_path(session[:cart])

      OrderProduct.count.must_equal start_count + 1
      Order.count.must_equal orders_start + 1
    end

    it "creates a new OrderProduct with a product and an order if doesn't exist already, adds to existing cart if it has already been initiated" do
      post create_order_product_path, params: @product_params
      #I have to do this in order to set session.

      orders_start = Order.count
      start_count = OrderProduct.count


      new_product = {
        product_id: products(:tripod).id,
        quantity: 1
      }

      post create_order_product_path, params: new_product
      must_redirect_to order_path(session[:cart])

      OrderProduct.count.must_equal start_count + 1
      Order.count.must_equal orders_start
    end

    it "if an OrderProduct with the same product already exists, it will not create a new OrderProduct object" do
      post create_order_product_path, params: @product_params

      orders_start = Order.count
      start_count = OrderProduct.count

      post create_order_product_path, params: @product_params
      must_redirect_to order_path(session[:cart])

      OrderProduct.count.must_equal start_count
      Order.count.must_equal orders_start
    end

    it "changes the quantity of an existing OrderProduct if trying to add more of the same product" do
      post create_order_product_path, params: @product_params

      op = OrderProduct.find_by(order_id: session[:cart])
      quantity_start = op.quantity

      # binding.pry
      post create_order_product_path, params: @product_params

      op.reload
      op.quantity.must_equal quantity_start + 1
    end

    it "wont create if input is invalid" do
      bad_product_params = {
        product_id: products(:tricycle).id,
        quantity: 0
      }
      start_count = OrderProduct.count

      post create_order_product_path, params: bad_product_params
      must_respond_with :bad_request
      flash[:message].must_equal "Could not update cart."

      OrderProduct.count.must_equal start_count
    end

    it "wont create if quantity is larger than inventory" do
      bad_product_params = {
        product_id: products(:tricycle).id,
        quantity: (products(:tricycle).inventory + 1)
      }
      start_count = OrderProduct.count

      post create_order_product_path, params: bad_product_params
      must_respond_with :bad_request
      flash[:message].must_equal "Not enough tricycles in stock, please revise the quantity selected."

      OrderProduct.count.must_equal start_count
    end
  end

  describe "update" do
    it "changes the quantity of an existing OrderProduct, if enough inventory" do
      post create_order_product_path, params: @product_params
      order_prod = OrderProduct.last

      update_order_prod = {
        product_id: order_prod.product_id,
        quantity: 2
      }
      patch order_product_path(order_prod.id), params: update_order_prod

      must_respond_with :redirect
      must_redirect_to order_path(order_prod.order)
      flash[:status].must_equal :success

      order_prod.reload
      order_prod.quantity.must_equal 2
    end

    it "sets flash[:status] to failure if there isn't enough inventory to update" do
      post create_order_product_path, params: @product_params
      order_prod = OrderProduct.last

      update_order_prod = {
        product_id: order_prod.product_id,
        quantity: 10
      }
      patch order_product_path(order_prod.id), params: update_order_prod

      must_respond_with :bad_request
      flash[:status].must_equal :failure
    end
  end
end
