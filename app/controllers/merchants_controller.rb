class MerchantsController < ApplicationController

before_action :find_id_by_params, except: [:index, :new, :create]

  def index
    @merchants = Merchant.all
  end

  def new
    @merchant = Merchant.new
  end

  def create
    @merchant = Merchant.new(merchant_params)
    # @merchant.user_id = session[:user_id]
    if @merchant.save
      # @merchant = session[:user_id]
      flash[:status] = :success
      flash[:result_text] = "Successfully created: #{@merchant.username}"
      redirect_to merchant_path(@merchant.id)
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not create new merchant"
      flash[:messages] = @merchant.errors.messages
      render :new, status: :bad_request
    end
  end

  def show
    @merchant = Merchant.find_by(id: params[:id])
  end

  def edit
  end

  def update
    # if @merchant.user_id != session[:user_id]
    #   flash[:status] = :failure
    #   flash[:result_text] = "Only the merchant has permission to do this"
    #   redirect_to root_path
    # else
      @merchant.update_attributes(merchant_params)
      if @merchant.save
        flash[:status] = :success
        flash[:result_text] = "Successfully updated"
        redirect_to merchant_path(@merchant)
      else
        flash.now[:status] = :failure
        flash.now[:result_text] = "Could not update"
        flash.now[:messages] = @merchant.errors.messages
        render :edit, status: :not_found
      end
    end

    def destroy
    # if @merchant.user_id != session[:user_id]
    #   flash[:status] = :failure
    #   flash[:result_text] = "Only the merchant has permission to delete"
    #   redirect_to root_path
    # else
      @merchant.destroy
      flash[:status] = :success
      flash[:result_text] = "Successfully deleted"
      # redirect_to root_path
      redirect_to merchants_path
    end

  private

  def merchant_params
    params.require(:merchant).permit(:username, :email)
  end

  def find_id_by_params
    @merchant = Merchant.find_by(id: params[:id])
    unless @merchant
      head :not_found
    end
  end
end
