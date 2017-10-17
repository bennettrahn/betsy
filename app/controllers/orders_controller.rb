class OrdersController < ApplicationController
  before_action :find_work_by_params_id, only: [:show, :edit, :update, :destroy]

  def index
    @books = Work.sort_by_category("book")
    @albums = Work.sort_by_category("album")
    @movies = Work.sort_by_category("movie")
  end

  def create
    @work = Work.new(work_params)

    if save_and_flash(@work)
      redirect_to work_path(@work)
    else
      render :new, status: :bad_request
    end

  end

  def new
    @work = Work.new
  end

  def edit
  end

  def show
  end

  def update
    @work.update_attributes(work_params)
    if save_and_flash(@work, edit:"updated")
      redirect_to(work_path(@work))
    else
      render :edit, status: :bad_request
    end
  end

  def destroy
    save_and_flash(@work, edit: "destroyed", save: @work.destroy)
    redirect_to root_path
  end

  private
  def work_params
    return params.require(:work).permit(:category, :title, :creator, :publication_year, :description)
  end

  def find_work_by_params_id
    @work = Work.find_by(id: params[:id])
    head :not_found unless @work
  end
end
