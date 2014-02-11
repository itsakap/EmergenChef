class UsersController < ApplicationController
  def index
    @users = User.all
  end
  def new
    @user = User.new
  end
  def create
    creation = params.require(:user).permit(:username, :email_address,:password)
    User.create(creation)

    Confirmer.welcome(creation).deliver
    redirect_to root_path
    flash[:notice] = "A confirmation e-mail has been sent to your account"
    
  end


private
  #def set_user?
  #end
  def user_params
    params.require(:user).permit(:username, :email_address, :salt, :hashed_password)
  end

end
