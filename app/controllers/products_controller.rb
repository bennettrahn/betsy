class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy, :retire]
  before_action :must_be_logged_in, only: [:new, :destroy, :edit]
  before_action :must_be_merchant_of_product, only: [:destroy, :edit]

  def root
    @all_products_for_season_cat = Category.root_page_seasonal_pick
  end

  def index
    @products = Product.not_retired
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
      if save_and_flash(@product)
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
    if save_and_flash(@product, edit: "update")
      redirect_back(fallback_location: product_path(@product))
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

  def retire
    @product.retired = !@product.retired
    save_and_flash(@product, edit: 'retire')
    # flash unretire?
    redirect_back(fallback_location: product_path(@product))
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
