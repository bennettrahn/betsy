class OrderProductsController < ApplicationController
  def create
    if session[:cart]
      @order = session[:cart]
    else
      order = Order.create(status:"pending")
      @order = order.id
      session[:cart] = order.id
    end
    @order_product = OrderProduct.new(quantity: params[:quantity], product_id: params[:product_id], order_id: @order)

    @order_product.save

    redirect_to order_path(@order)
    # redirect_to orders_path
  end

end
