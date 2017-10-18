class ReviewsController < ApplicationController
  def new
    @review = Review.new
  end
  def create
    @review = Review.new(
    review_params
    )
  
    if @review.save
      redirect_to products_path
    else
      render :new, status: :bad_request
    end
  end
end

private
def review_params
  return params.require(:review).permit(:rating, :text, :product_id)
end
