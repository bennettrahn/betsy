class CategoriesController < ApplicationController
  before_action :must_be_logged_in, only: [:new, :create]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if save_and_flash(@category, edit: "created", save: @category.save )
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
end
