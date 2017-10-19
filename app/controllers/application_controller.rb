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

end
