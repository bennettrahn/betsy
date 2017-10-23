class ReviewsController < ApplicationController

before_action :find_product, only: [:new]

  def new
    if session[:merchant_id] == @product.merchant_id
      flash[:status] = :failure
      flash[:message] = "You cannot review your own product!"
      redirect_to products_path
      return
    else
      @review = Review.new
    end
  end

  def create
    # @product = Product.find_by(id: params[:product_id])
    # cant_be_merchant
    @review = Review.new(
    review_params
    )
    @product = Product.find_by(id: review_params[:product_id])
    if save_and_flash(@review)
      redirect_to product_path(review_params[:product_id])
      return
    else
      render :new, status: :bad_request
    end
  end
end

private

def find_product
  @product = Product.find_by(id: params[:product_id])
  unless @product
    head :not_found
  end
end

def review_params
  return params.require(:review).permit(:rating, :text, :product_id)
end

# def cant_be_merchant
#   if session[:merchant_id] == @product.merchant_id
#     flash[:status] = :failure
#     flash[:message] = "You cannot review your own product!"
#     redirect_to products_path
#     return
#   end
# end
