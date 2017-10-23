require "test_helper"

describe OrderProductsController do
  before do
    @product_params = {
      product_id: products(:tricycle).id,
      quantity: 1
    }
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

    #TODO: this test is failing
    it "changes the quantity of an existing OrderProduct if trying to add more of the same product" do
      post create_order_product_path, params: @product_params
      # order = Order.find_by(id: session[:cart])
      # quantity_start = 0
      # order.order_products.each do |op|
      #   quantity_start += op.quantity
      # end
      # binding.pry
      # op = order.order_product
      op = OrderProduct.find_by(order_id: session[:cart])
      quantity_start = op.quantity

      # binding.pry
      post create_order_product_path, params: @product_params
      # quantity_end = 0
      # order.order_products.each do |op|
      #   quantity_end += op.quantity
      # end
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
      flash[:message].must_equal "A problem occurred: Could not created OrderProduct"

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
    it "changes the quantity of an existing OrderProduct" do
      post create_order_product_path, params: @product_params
      order_prod = OrderProduct.last
      puts "ORDER PRODUCT ID: #{order_prod.id}"

      update_order_prod = {
        product_id: order_prod.product_id,
        quantity: 2
      }
      patch order_product_path(order_prod.id), params: update_order_prod

      puts "ORDER_ID in test: #{order_prod.order.id}"
      must_respond_with :redirect
      must_redirect_to order_path(order_prod.order)

      order_prod.reload
      order_prod.quantity.must_equal 2
    end

    it "sets flash[:status] to failure if there isn't enough inventory to update" do

    end

    it "sets flash[:status] to success if enough inventory" do

    end
  end
end
