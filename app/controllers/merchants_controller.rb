class MerchantsController < ApplicationController

before_action :find_id_by_params, except: [:index, :new, :create]

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find_by(id: params[:id])
  end

  private

  def find_id_by_params
    @merchant = Merchant.find_by(id: params[:id])
    unless @merchant
      head :not_found
    end
  end

end
