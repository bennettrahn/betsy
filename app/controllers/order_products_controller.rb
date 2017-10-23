class OrderProductsController < ApplicationController
  # before_action :find_op_by_params_id, only: [:edit, :update]
  def update
    @op = OrderProduct.find_by(id: params[:id])

    @product = Product.find_by(id: params[:product_id])
    new_quantity = params[:quantity].to_i

    #find instance of order
    order_id = session[:cart]
    @order = Order.find_by(id: order_id)

    #put previous quantity back to inventory
    @product.increase_inventory(@op.quantity)

    if @product.check_inventory(new_quantity)
      @op.quantity = new_quantity
      if @op.save
        flash[:status] = :success
        flash[:message] = "Successfully updated cart"
        redirect_to order_path(@order.id)
      else
        render "orders/show", status: :bad_request
      end
    else #not enough inventory
      flash.now[:status] = :failure
      flash.now[:message] = "Not enough #{@product.name.pluralize} in stock, please revise the quantity selected."
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
        @order_product = OrderProduct.new(quantity: quantity, product_id: params[:product_id], order_id: @order)
        #decrease inventory of product (doesn't seem to be working)
        # @product.decrease_inventory(quantity)
        if save_and_flash(@order_product, edit:"created")
          redirect_to order_path(@order)
        else
          render "products/show", status: :bad_request
        end
      else #there is an op in result(should be just one)
        @op = result[0]
        #decrease inventory by quantity
        # @product.decrease_inventory(quantity)
        new_quantity = @op.quantity + quantity
        @op.quantity = new_quantity
        if save_and_flash(@op, edit:"updated")
          redirect_to order_path(@order)
        else
          render "products/show", status: :bad_request
        end
      end

    else
      flash.now[:status] = :failure
      flash.now[:message] = "Not enough #{@product.name.pluralize} in stock, please revise the quantity selected."
      render "products/show", status: :bad_request
    end
  end

  def destroy
    @op = OrderProduct.find_by(id: params[:id])
    @order = Order.find_by(id: @op.order.id)

    save_and_flash(@op, edit: "deleted", save: @op.destroy)
    redirect_to(order_path(@order))

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

  def find_op_by_params_id
    @op = OrderProduct.find_by(id: params[:id])
    head :not_found unless @op
  end

end
