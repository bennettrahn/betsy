class OrderProductsController < ApplicationController
  # before_action :find_op_by_params_id, only: [:edit, :update]
  def update_status
    @op = OrderProduct.find_by(id: params[:id])
    @op.status = "complete"
    @op.save
    if @op.order.order_complete?
      @op.order.status = "complete"
      @op.order.save
      flash[:status] = :success
      flash[:message] = "Order has been completed and shipped to buyer"
      redirect_to merchant_path(@op.product.merchant)
      return
    end
    flash[:status] = :success
    flash[:message] = "Product has been added to order, Order is waiting on other products before shipping."
    redirect_to merchant_path(@op.product.merchant)
  end

  def update
    @op = OrderProduct.find_by(id: params[:id])
    # @product = @op.product

    @product = Product.find_by(id: params[:product_id])
    new_quantity = params[:quantity].to_i

    #find instance of order
    order_id = session[:cart]
    @order = Order.find_by(id: order_id)

    if @product.check_inventory(new_quantity)
      @op.quantity = new_quantity
      if save_and_flash_cart
        redirect_to order_path(@order.id)
      else
        render "orders/show", status: :bad_request
      end
    else #not enough inventory
      not_enough_inventory
      render "orders/show", status: :bad_request
    end
  end

  def create
    assign_order
    @product = Product.find_by(id: params[:product_id])

    quantity = params[:quantity].to_i

    if @product.check_inventory(quantity)
      #find order object
      order = Order.find_by(id: @order)

      #check if this order already has this product
      result = order.order_products.select {|op| op.product_id == @product.id}

      if result.empty? #no current products with this id
        @op = OrderProduct.new(quantity: quantity, product_id: params[:product_id], order_id: @order)
      else #there is an op in result(should be just one)
        @op = result[0]

        new_quantity = @op.quantity + quantity
        @op.quantity = new_quantity
      end

      if save_and_flash_cart
        redirect_to order_path(@order)
      else
        render "products/show", status: :bad_request
      end

    else
      not_enough_inventory
      render "products/show", status: :bad_request
    end
  end

  def destroy
    @op = OrderProduct.find_by(id: params[:id])
    @order = Order.find_by(id: @op.order.id)
    # if there is still content in the cart, show

    save_and_flash(@op, edit: "delete", save: @op.destroy, name: "item")

    if @order.order_products.empty?
      session[:cart] = nil
      redirect_to order_empty_cart_path(:cart)
    else
      redirect_to order_path(@order)
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

  # def order_params
  #   return params.require(:order_product).permit(:quantity, :product_id)
  # end
  def not_enough_inventory
    flash.now[:status] = :failure
    flash.now[:message] = "Not enough #{@product.name.pluralize} in stock, please revise the quantity selected."
  end

  def find_op_by_params_id
    @op = OrderProduct.find_by(id: params[:id])
    head :not_found unless @op
  end

  def save_and_flash_cart
    if @op.save
      flash[:status] = :success
      flash[:message] = "Successfully updated cart"
    else
      flash.now[:status] = :failure
      flash.now[:message] = "Could not update cart."
      flash.now[:details] = @op.errors.messages
      return false
    end
  end

end
