class CategoriesController < ApplicationController
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
