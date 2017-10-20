class OrderProductsController < ApplicationController
  def create
    assign_order
    @product = Product.find_by(id: params[:product_id])

    quantity = params[:quantity].to_i

    if @product.check_inventory(quantity)
      @order_product = OrderProduct.new(quantity: quantity, product_id: params[:product_id], order_id: @order)
      if save_and_flash(@order_product, edit:"created")
        redirect_to order_path(@order)
      else
        render "products/show", status: :bad_request
      end
    else
      flash[:status] = :failure
      flash[:message] = "Not enough #{@product.name.pluralize} in stock, please revise the quantity selected."
      render "products/show", status: :bad_request
    end
  end

private
  def assign_order
    if session[:cart]
      @order = session[:cart]
    else
      order = Order.create(status:"pending")
      @order = order.id
      session[:cart] = order.id
    end
  end

end
