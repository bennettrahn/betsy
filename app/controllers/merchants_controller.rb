class MerchantsController < ApplicationController

  before_action :find_id_by_params, except: [:index, :create, :logout]
  before_action :must_be_logged_in, only: [:destroy]

  def index
    @merchants = Merchant.all
  end

  def create
    auth_hash = request.env['omniauth.auth']
    session[:cart] = nil
    if auth_hash['uid']
      merchant = Merchant.find_by(provider: params[:provider], uid: auth_hash[:uid])
      if merchant.nil? #merchant hasn't logged in before
        merchant = Merchant.from_auth_hash(params[:provider], auth_hash)
        save_and_flash(merchant)
      else #merchant has logged in before
        flash[:status] = :success
        flash[:message] = "Successfully logged in as returning merchant #{merchant.name}"
      end

      if session[:merchant_id] == merchant.id
        flash[:status] = :failure
        flash[:message] = "You're already logged in, Bae!"
      else
        session[:merchant_id] = merchant.id
      end

    else
      flash[:status] = :failure
      flash[:message] = "Could not create merchant from OAuth data"
      # this might be redundant, because save_and_flash might do this anyway?
    end

    redirect_to products_path
  end

  def logout
    session[:merchant_id] = nil
    session[:cart] = nil
    flash[:status] = :success
    flash[:message] = "You have been logged out."
    redirect_to products_path
  end

  def show(status: nil)
    @paid_orders = @merchant.sort_orders_by_status("paid")
    @complete_orders = @merchant.sort_orders_by_status("complete")
    if params[:status] == "paid" || params[:status] == nil
      @filtered_orders = @paid_orders
      @title = "Waiting to be fulfilled:"
    elsif params[:status] == "complete"
      @filtered_orders = @complete_orders
      @title = "Completed orders:"
    end
  end

  def destroy
    if @merchant.id != session[:merchant_id]
      flash[:status] = :failure
      flash[:message] = "Only the merchant has permission to delete"
      redirect_to root_path
    else
      @merchant.destroy
      flash[:status] = :success
      flash[:message] = "Successfully deleted"
      redirect_to merchants_path
    end
  end

  private

  def check_this_merchant
    if @merchant.id != session[:merchant_id]
      flash[:status] = :failure
      flash[:message] = "Only the merchant has permission to do this."
      return false
    end
    return true
  end

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
