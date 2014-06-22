class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  helper_method :current_user, :is_admin?
  protect_from_forgery with: :exception

  def current_user
    if session[:user_id]
      User.find_by(id: session[:user_id])
      #session[:user_id] = nil
    end
  end
  def is_admin?
    if current_user
      "#{current_user.id}" == "#{ENV['EMERGENCHEF_ADMIN_USER_ID']}"
    end
  end
end
