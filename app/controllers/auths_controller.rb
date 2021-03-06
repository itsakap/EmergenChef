class AuthsController < ApplicationController
  def new
    if current_user
      redirect_to users_path
    else
      @user = User.new
    end
  end
  #this is dry enough
  def create
    user = User.where(username: params[:user][:username])
    if user.count > 0
      @user = user[0]
      if @user.passes_authentication?(params[:user][:password])
        if @user.is_verified?
          session[:user_id] = @user.id
          redirect_to @user
        else
          #must click link to verify
          redirect_to new_auth_path
          flash[:error] = "Please check your e-mail and verify your identity. &nbsp; &nbsp; #{ ActionController::Base.helpers.link_to 'Resend Email', resend_path(@user) }".html_safe #resend verification e-mail link
        end
      else
        #invalid password
        redirect_to new_auth_path
        flash[:error] = 'Invalid username and/or password.  Please try again.'
      end
    else
      #invalide username
      redirect_to new_auth_path
      flash[:error] = 'Invalid username and/or password.  Please try again.'
    end
  end
  def resend_verification_email
    @user = User.find(params[:id])
    Confirmer.delay.welcome(@user.id)
    redirect_to new_auth_path
    flash[:notice] = 'Please check your e-mail.'
  end
  def destroy
    session[:user_id] = nil
    redirect_to new_auth_path
  end

end