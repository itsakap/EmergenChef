class UsersController < ApplicationController
  def index
    @users = User.all
    if current_user
      redirect_to current_user
    end
  end
  def new
    unless current_user
      @user = User.new
    else redirect_to root_path
    end
  end
  def create
    creation = params.require(:user).permit(:username, :email_address,:password, :password_confirmation,:is_verified?, :verification_token)
    @user = User.new(creation)
    if creation[:password] == creation[:password_confirmation] && @user.save
      
      Confirmer.delay.welcome(@user.id)
      redirect_to root_path
      flash[:notice] = "A confirmation e-mail has been sent to your account."
    else
      redirect_to new_user_path
      flash[:notice] = @user.save ? "Please confirm your password properly." : "Username already exists"
    end
  end

  def verify
    @user = User.find(params[:id])
    if @user.verification_token == params[:verification_token]
      @user.update(:is_verified? => true, :verification_token => nil)
      redirect_to new_auth_path
      flash[:notice] = 'you are so cool'
    else
      flash[:notice] = "fuck off you evil hacker fart"
      redirect_to root_path
    end
  end
  def show
    unless current_user
      redirect_to new_auth_path
    end
    unless current_user.profile
      Profile.create(user: current_user)

    end
  end
  def update
    unless current_user
      redirect_to new_auth_path
    else
      if current_user.update(params.require(:user).permit(:email, profile_attributes: [:phone_number, :startup_name]))

        redirect_to current_user
      end
    end
  end
private

  def user_params
    params.require(:user).permit(:username, :email_address, :salt, :hashed_password)
  end

end
