class OrderProductsController < ApplicationController
  def create
    order = Order.create(status:"this is a test")
    @order_product = OrderProduct.new(product_id: params[:product_id], order_id: order.id)

    @order_product.save

    redirect_to order_path(order)
  end

end
