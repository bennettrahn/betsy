class OrdersController < ApplicationController
  before_action :find_order_by_params_id, only: [:show, :update, :destroy, :checkout, :receipt]
  before_action :check_order_session, only: [:receipt]

  def index
    @orders = Order.all
  end

  def show ; end


  def checkout ; end

  def receipt ; end

  def update
    @order.update_attributes(order_params)
    flash[:receipt] = order_params[:buyer_name]
    @order.status = "paid"
    session[:cart] = nil
    if save_and_flash(@order, edit:"submitted", name: @order.id)
      redirect_to order_receipt_path(@order.id)
    else
      render :checkout, status: :bad_request
      redirect_to(order_path(@order))
    end
  end

  def destroy
    save_and_flash(@order, edit: "destroyed", save: @order.destroy, name: @order.id)
    session[:cart] = nil
    redirect_to root_path
  end

  private
  def order_params
    return params.require(:order).permit(:status, :email, :mailing_address, :buyer_name, :card_number, :expiration, :cvv, :zipcode)
  end

  def find_order_by_params_id
    @order = Order.find_by(id: params[:id] || params[:order_id])
    head :not_found unless @order
  end

  def check_order_session
    if flash[:receipt] != @order.buyer_name
      flash[:status] = :failure
      flash[:message] = "Sorry, you cannot view that receipt."
      redirect_to root_path
    end
  end
end
