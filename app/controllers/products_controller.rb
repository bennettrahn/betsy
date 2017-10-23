class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy]
  before_action :must_be_logged_in, only: [:new, :destroy, :edit]
  before_action :must_be_merchant_of_product, only: [:destroy, :edit]

  def root
    
  end

  def index
    @products = Product.all
    # @categories = Category.all
  end

  def show ; end

  def new
    @product = Product.new
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
    return params.require(:product).permit(:name, :description, :price, :inventory, :photo_url, :category_ids => [])
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    unless @product
      head :not_found
    end
  end

end
