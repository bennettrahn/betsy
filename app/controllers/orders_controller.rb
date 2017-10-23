class OrdersController < ApplicationController
  before_action :find_order_by_params_id, only: [:show, :update, :destroy, :checkout]

  def index
    @orders = Order.all
  end

  def show ; end

  def update
    @order.update_attributes(order_params)
    if save_and_flash(@order, edit:"submitted", name: @order.id)
      @order.status = "paid"
      session[:cart] = nil
      redirect_to(order_path(@order))
      # at some point this should be a reciept page of some kind
    else
      render :checkout, status: :bad_request
    end
  end

  def destroy
    save_and_flash(@order, edit: "destroyed", save: @order.destroy, name: @order.id)
    redirect_to orders_path
  end

  def checkout ; end

  private
  def order_params
    return params.require(:order).permit(:status, :email, :mailing_address, :buyer_name, :card_number, :expiration, :cvv, :zipcode)
  end

  def find_order_by_params_id
    @order = Order.find_by(id: params[:id])
    head :not_found unless @order
  end

end
