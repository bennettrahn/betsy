class OrdersController < ApplicationController
  before_action :find_order_by_params_id, only: [:show, :update, :destroy, :checkout, :receipt]

  def index
    @orders = Order.all
  end

  def show ; end

  # def edit
  # end
  def checkout ; end

  def receipt ; end

  def update
    @order.update_attributes(order_params)
    # if save_and_flash(@order, edit:"submitted")
    flash[:receipt] = true
    @order.status = "paid"

    # session[:cart] = nil

    # @order.save
    # at some point this should be a reciept page of some kind
    if @order.save
      # render partial: "receipt", locals: { action_name: "checkout" }
      redirect_to order_receipt_path(@order.id)
    else
      render :checkout, status: :bad_request
      redirect_to(order_path(@order))
    end
  end

  def destroy
    save_and_flash(@order, edit: "destroyed", save: @order.destroy)
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

end
