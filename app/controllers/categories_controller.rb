class CategoriesController < ApplicationController
  before_action :must_be_logged_in, only: [:new, :create]
  before_action :find_id_by_params, only: [:show]

  def index
    @categories = Category.all
    @spot = Category.spot
    # @by_cat = Category.view_by_category
  end

  def show ; end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if save_and_flash(@category)
      redirect_to products_path
      return
    else
      render :new, status: :bad_request
    end
  end

  private

  def category_params
    return params.require(:category).permit(:name)
  end

  def find_id_by_params
    @category = Category.find_by(id: params[:id])
    unless @category
      head :not_found
    end
  end
end
