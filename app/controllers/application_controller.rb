class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  helper_method :current_user, :is_admin? # consider adding: , :this_user
  protect_from_forgery with: :exception
  #user that is logged in
  def current_user
    if session[:user_id]
      User.find_by(id: session[:user_id])
    end
  end
  def is_admin?
    if current_user
      "#{current_user.id}" == "#{ENV['EMERGENCHEF_ADMIN_USER_ID']}"
    end
  end
  #consider adding helper method for identifying user currently in view; with addition of admin mode, it will not always be current_user
end
