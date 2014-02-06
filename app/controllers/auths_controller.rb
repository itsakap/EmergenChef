class AuthsController < ApplicationController
  def new
    if current_user
      redirect_to users_path
    else
      @user = User.new
    end
  end
  def create
    @user = User.find_by(username: params[:user][:username])
    if @user.passes_authentication?(params[:user][:password])
      session[:user_id] = @user.id
      redirect_to users_path
    end
  end
  def destroy
  end

end