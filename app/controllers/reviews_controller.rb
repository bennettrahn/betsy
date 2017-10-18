class ReviewsController < ApplicationController
  def new
    @review = Review.new
    @product = Product.find_by(id: params[:product_id])
  end

  def create
    @product = Product.find_by(id: params[:product_id])
    @review = Review.new(
    review_params
    )
    if @review.save
      redirect_to product_path(@product)
    else
      render :new, status: :bad_request
    end
  end

  def show
    @review = Review.find_by[id: params[:id]]
  end
end

private
def review_params
  return params.require(:review).permit(:rating, :text, :product_id)
end
