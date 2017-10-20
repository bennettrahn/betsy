class OrderProductsController < ApplicationController
  before_action :find_op_by_params_id, only: [:edit, :update]
  def edit

  end

  def update
    @op.update_attributes(order_params)

    @product = Product.find_by(id: params[:product_id])
    quantity = params[:quantity].to_i

    if @product.check_inventory(quantity)
      if save_and_flash(@order, edit:"updated")
        redirect_to(order_path(@order))
      else
        render :edit, status: :bad_request
      end
    else
      flash.now[:status] = :failure
      flash.now[:message] = "Not enough #{@product.name.pluralize} in stock, please revise the quantity selected."
      render "products/show", status: :bad_request
    end
  end

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
      flash[:status].now = :failure
      flash[:message].now = "Not enough #{@product.name.pluralize} in stock, please revise the quantity selected."
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

  def order_params
    return params.require(:order_product).permit(:quantity, :product_id)
  end

  def find_op_by_params_id
    @op = OrderProduct.find_by(id: params[:id])
    head :not_found unless @op
  end

end
