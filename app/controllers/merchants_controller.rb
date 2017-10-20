class MerchantsController < ApplicationController

before_action :find_id_by_params, except: [:index, :new, :create, :logout]

  def index
    @merchants = Merchant.all
  end

  def new
    @merchant = Merchant.new
  end

  def create
    auth_hash = request.env['omniauth.auth']

    if auth_hash['uid']
      merchant = Merchant.find_by(provider: params[:provider], uid: auth_hash[:uid])
      if merchant.nil? #merchant hasn't logged in before
        merchant = Merchant.from_auth_hash(params[:provider], auth_hash)
        save_and_flash(merchant)
      else #merchant has logged in before
        flash[:status] = :success
        flash[:message] = "Successfully logged in as returning merchant #{merchant.name}"
      end

      session[:merchant_id] = merchant.id

    else
      flash[:status] = :failure
      flash[:message] = "Could not create merchant from OAuth data"
    end

    redirect_to products_path
  end

  def logout
    session[:merchant_id] = nil
    flash[:status] = :success
    flash[:message] = "You have been logged out"
    redirect_to products_path
  end

  def show
    @merchant = Merchant.find_by(id: params[:id])
  end

  def edit
  end

  def update
    # if @merchant.id != session[:merchant_id]
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
    # if @merchant.id != session[:merchant_id]
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

  def save_and_flash(model)
    result = model.save

    if result
      puts "result: #{result}"
      flash[:status] = :success
      flash[:message] = "Successfully saved #{model.class} #{model.name}"
    else
      flash.now[:status] = :failure
      flash.now[:message] = "Failed to save #{model.class}"
      flash.now[:details] = model.errors.messages
    end

    puts "In save_and_flash: Result: #{result}"

    return result
  end
end
