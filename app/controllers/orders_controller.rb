class OrdersController < ApplicationController
  before_action :find_order_by_params_id, only: [:show, :edit, :update, :destroy]

  def index
    @orders = Order.all
  end

  def create
    @order = Order.new(order_params)

    if save_and_flash(@order)
      redirect_to order_path(@order)
    else
      render :new, status: :bad_request
    end

  end

  def new
    @order = Order.new
  end

  def edit
  end

  def show
  end

  def update
    @order.update_attributes(order_params)
    if save_and_flash(@order, edit:"updated")
      redirect_to(order_path(@order))
    else
      render :edit, status: :bad_request
    end
  end

  def destroy
    save_and_flash(@order, edit: "destroyed", save: @order.destroy)
    redirect_to orders_path
  end

  private
  def order_params
    return params.require(:order).permit(:status, :email, :mailing_address, :buyer_name, :card_number, :expiration, :cvv, :zipcode)
  end

  def find_order_by_params_id
    @order = Order.find_by(id: params[:id])
    head :not_found unless @order
  end

  def save_and_flash(model, edit: "created", save: model.save)
    result = save
    if result
      flash[:status] = :success
      flash[:message] = "Successfully #{edit} #{model.class} #{model.id}"
    else
      flash.now[:status] = :failure
      flash.now[:message] = "A problem occurred: Could not create #{model.class}"
      flash.now[:details] = model.errors.messages
      return false
    end
  end
end
