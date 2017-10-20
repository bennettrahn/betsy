class OrderProductsController < ApplicationController
  def create
    if session[:cart]
      @order = session[:cart]
    else
      order = Order.create(status:"pending")
      @order = order.id
      session[:cart] = order.id
    end
    @product = Product.find_by(id: params[:product_id])
    @order_product = OrderProduct.new(quantity: params[:quantity], product_id: params[:product_id], order_id: @order)
    if save_and_flash(@order_product, edit:"created")
      #I don't think these flash messages are what we want, but I can't test it, so its staying like this for awhile
      @product.decrease_inventory(params[:quantity])

      redirect_to order_path(@order)
    else
      render "products/show", status: :bad_request
    end
    # redirect_to orders_path
  end

end
