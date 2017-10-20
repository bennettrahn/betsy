class ReviewsController < ApplicationController

  def new
    @product = Product.find_by(id: params[:product_id])
    if session[:merchant_id] == @product.merchant_id
      flash[:status] = :failure
      flash[:message] = "You cannot review your own product!"
      redirect_to products_path
    end
    @review = Review.new
  end

  def create
    # @product = Product.find_by(id: params[:product_id])
    @review = Review.new(
    review_params
    )
    if save_and_flash(@review, edit: "saved", save: @review.save )
      redirect_to product_path(review_params[:product_id])
      return
    else
      render :new, status: :bad_request
    end
  end
end

private
def review_params
  return params.require(:review).permit(:rating, :text, :product_id)
end
