class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  protected

  # def require_login
  #   @merchant = Merchant.find_by(id: session[:user_id])
  #   unless @merchant
  #     flash[:status] = :failure
  #     flash[:message] = "You must be logged in to do that!"
  #     redirect_to products_path
  #   end
  # end

  # def save_and_flash(model)
  #   result = model.save
  #   if result
  #     flash[:status] = :success
  #     flash[:message] = "Succesfully saved #{model.class} #{model.name}"
  #   else
  #     flash.now[:status] = :failure
  #     flash.now[:message] = "Failed to save #{model.class}"
  #     flash.now[:details] = model.errors.messages
  #   end
  #   return result
  # end
  def must_be_logged_in
    if session[:merchant_id] == nil
      flash[:status] = :failure
      flash[:message] = "You must be logged in to do that!"
      redirect_to products_path
    end
  end

  def must_be_merchant_of_product
    if session[:merchant_id] != @product.merchant_id
      flash[:status] = :failure
      flash[:message] = "You must be the owner of this product to do that!"
      redirect_to products_path
    end
  end

  def save_and_flash(model, edit: "", save: model.save)
    result = save
    if result
      flash[:status] = :success
      flash[:message] = "Successfully #{edit} #{model.class} #{model.id}"
    else
      flash.now[:status] = :failure
      flash.now[:message] = "A problem occurred: Could not #{edit} #{model.class}"
      flash.now[:details] = model.errors.messages
      return false
    end
  end
end
