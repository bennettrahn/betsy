class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy]
  def root
  end
  def index
    @products = Product.all
  end

  def show ; end

  def new
    if session[:merchant_id] == nil
      flash[:status] = :failure
      flash[:message] = "You must be logged in to do that!"
      redirect_to products_path
    else
      @product = Product.new
    end
  end

  def create
    @product = Product.new(
    product_params
    )
    @product.merchant_id = session[:merchant_id]

    if save_and_flash(@product, edit: "created", save: @product.save )
      redirect_to products_path
      return
    else
      render :edit, status: :bad_request
    end
  end

  def edit ; end

  def update
    @product.merchant_id = session[:merchant_id]
    @product.update_attributes(product_params)
    if save_and_flash(@product, edit: "updated", save: @product.save )
      redirect_to product_path(@product)
      return
    else
      render :edit, status: :bad_request
    end
  end

  def destroy
    @product.destroy
    flash[:status] = :success
    flash[:message] = "Successfully deleted!"
    redirect_to products_path
  end


  private

  def product_params
    return params.require(:product).permit(:name, :description, :price, :inventory, :photo_url)
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    unless @product
      head :not_found
    end
  end

end
