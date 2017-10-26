class OrdersController < ApplicationController
  before_action :find_order_by_params_id, only: [:show, :update, :destroy, :checkout, :receipt, :check_merchant_is_prod_owner]
  before_action :check_order_session, only: [:receipt]
  before_action :check_cart, only:[:show]

  def index
    @orders = Order.all
  end

  def show ; end


  def checkout
    @payment_info = PaymentInfo.new
  end

  def receipt
    @payment_info = @order.payment_info
    @last_four_cc = @payment_info.last_four_cc
  end

  def update
    @payment_info = PaymentInfo.new
    @payment_info.update_attributes(payment_params)
    @payment_info.order = @order
    if save_and_flash(@payment_info, name: @payment_info.buyer_name)
    else
      render :checkout, status: :bad_request
      return
    end
    flash[:receipt] = payment_params[:buyer_name]
    @order.status = "paid"
    update_order_items_status
    session[:cart] = nil

    if save_and_flash(@order, edit:"submitte", name: @order.id)
      @order.order_products.each do |op|
        op.product.decrease_inventory(op.quantity)
      end
      redirect_to order_receipt_path(@order.id)
    else
      render :checkout, status: :bad_request
      redirect_to(order_path(@order))
    end
  end

  def destroy
    save_and_flash(@order, edit: "destroye", save: @order.destroy, name: @order.id)
    session[:cart] = nil
    redirect_to root_path
  end

private
  def payment_params
    return params.require(:payment_info).permit(:email, :mailing_address, :buyer_name, :card_number, :expiration, :cvv, :zipcode)
  end

  def find_order_by_params_id
    @order = Order.find_by(id: params[:id] || params[:order_id])
    head :not_found unless @order
  end

  def check_order_session
    if (flash[:receipt] != @order.payment_info.buyer_name) && check_merchant_is_prod_owner != true
      flash[:status] = :failure
      flash[:message] = "Sorry, you cannot view that receipt."
      redirect_to root_path
    end
  end

  def update_order_items_status
    @order.order_products.each do |op|
      op.status = "paid"
      op.save
    end
  end

  def check_merchant_is_prod_owner
    @order.products.each do |prod|
      if prod.merchant_id == session[:merchant_id]
        return true
      end
    end
    return false
  end

  def check_cart
    if session[:cart] != params[:id].to_i
      flash[:status] = :failure
      flash[:message] = "Sorry, you cannot view that order."
      redirect_to root_path
    end

  end

end
