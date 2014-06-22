class UsersController < ApplicationController
  before_action :logout_required, except: [:show, :welcome, :index] #only new, create, verify, update
  before_action :login_required, only: [:update, :show, :index]
  before_action :admin_required, only: [:index]
  before_action :user_match_required, only:[:show]
  def index
    @users=User.all
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
      
      Confirmer.delay.welcome(@user.id) #
      redirect_to root_path
      flash[:notice] = "A confirmation e-mail has been sent to your account."
    else
      redirect_to new_user_path
      flash[:error] = @user.save ? "Please confirm your password properly." : "Username already exists."
    end
  end

  def verify
    @user = User.find(params[:id])
    if @user.verification_token == params[:verification_token]
      @user.update(:is_verified? => true, :verification_token => nil)
      redirect_to new_auth_path
      flash[:notice] = 'Account successfully verified!'
    else
      flash[:error] = "Oops!  Something went wrong!  Please try again."
      redirect_to root_path
    end
  end
  def show
      @orders = current_user.orders
    unless current_user.profile #profile does not exist yet
      Profile.create(user: current_user)

    end
  end
  def update
    unless current_user
      redirect_to new_auth_path
    else
      if current_user.update(params.require(:user).permit(:email, profile_attributes: [:phone_number, :address,:startup_name,:dietary_preferences,:favorite_foods,:credit_card_number,:expiration_date,:cvv,:how_frequently_your_team_pulls_all_nighters,:party_size]))
        flash[:notice] = "Successfully updated Profile"
        redirect_to current_user
      end
    end
  end
private

  def user_params
    params.require(:user).permit(:username, :email_address, :salt, :hashed_password)
  end
  def logout_required
    if current_user
      redirect_to current_user
    end
  end
  def login_required
    unless current_user
      redirect_to new_auth_path
    end
  end
  def admin_required
    unless current_user.id == ENV['EMERGENCHEF_ADMIN_USER_ID']
      redirect_to root_path
    end
  end
  def user_match_required
    unless ("#{current_user.id}" == "#{params[:id]}") || ("#{current_user.id}" == "#{ENV['EMERGENCHEF_ADMIN_USER_ID']}")
      redirect_to root_path
    end
  end
end
