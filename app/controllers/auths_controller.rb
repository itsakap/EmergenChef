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
      if @user.is_verified?
        session[:user_id] = @user.id
        redirect_to users_path
      else
        redirect_to new_auth_path
        flash[:notice] = "Please verify your identity" #add button for resending e-mail
      end
    else
      redirect_to new_auth_path
      flash[:notice] = 'not cool, homie'
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to new_auth_path
  end

end