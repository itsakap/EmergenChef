class UsersController < ApplicationController
  def index
    @users = User.all
  end
  def new
    @user = User.new
  end
  def create
    creation = params.require(:user).permit(:username, :email_address,:password, :password_confirmation,:is_verified, :verification_token)
    @user = User.new(creation)
    if creation[:password] == creation[:password_confirmation]
      @user.save
      Confirmer.welcome(@user).deliver
      redirect_to root_path
      flash[:notice] = "A confirmation e-mail has been sent to your account."
    else
      redirect_to new_user_path
      flash[:notice] = "Please confirm your password properly."
    end
  end

  def verify
    @user = User.find(params[:id])
    puts @user
    if @user.verification_token == params[:verification_token]
      @user.update(:is_verified => true, :verification_token => nil)
      redirect_to new_auth_path
      flash[:notice] = 'you are so cool'
    else
      flash[:notice] = "fuck off you evil hacker bitch fart"
      redirect_to root_path
    end
  end

private
  #def set_user?
  #end
  def user_params
    params.require(:user).permit(:username, :email_address, :salt, :hashed_password)
  end

end
