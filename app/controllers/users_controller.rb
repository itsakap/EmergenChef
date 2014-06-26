class UsersController < ApplicationController
  before_action :logout_required, except: [:show, :welcome, :index, :update] #only new, create, verify, update
  before_action :login_required, only: [:update, :show, :index]
  before_action :admin_required, only: [:index]
  before_action :user_match_required, only:[:show, :update]

  #admin-only action for easy access to all users in DB
  def index
    @users=User.all
  end

  #homepage; welcome users!
  def welcome
  end
  
  #action for sign up
  def new
    @user = User.new
  end

  #action for sign up
  def create
    creation = params.require(:user).permit(:username, :email_address,:password, :password_confirmation,:is_verified?, :verification_token)
    @user = User.new(creation)
    if creation[:password] == creation[:password_confirmation] && @user.save #double passwords match, and user passes AR validations
      Profile.create(user: @this_user) #create profile
      Confirmer.delay.welcome(@user.id) #send the user an e-mail
      redirect_to root_path #go to homepage
      flash[:notice] = "A confirmation e-mail has been sent to your account." #serve a notice
    else
      redirect_to new_user_path #go back to jail
      flash[:error] = @user.save ? "Please confirm your password properly." : "Username already exists." #validations could be stricter
    end
  end

  #action for e-mail verification
  def verify
    @user = User.find(params[:id])
    #verification token in DB should match verification token in URL
    if @user.verification_token == params[:verification_token]
      @user.update(:is_verified? => true, :verification_token => nil)
      redirect_to new_auth_path
      flash[:notice] = 'Account successfully verified!'
    else
      flash[:error] = "Oops!  Something went wrong!  Please try again."
      redirect_to root_path
    end
  end

  #launch pad for editing profile or orders
  def show
    @this_user = User.find(params[:id])
    @orders = @this_user.orders
    #the following block is slated for removal because it was moved into users#create 
    unless @this_user.profile
      Profile.create(user: @this_user)
    end
  end

  #action for updating a user
  def update
    @this_user = User.find(params[:id])
    if @this_user.update(params.require(:user).permit(:email, profile_attributes: [:phone_number, :address,:startup_name,:dietary_preferences,:favorite_foods,:credit_card_number,:expiration_date,:cvv,:how_frequently_your_team_pulls_all_nighters,:party_size]))
      flash[:notice] = "Successfully updated Profile"
      redirect_to @this_user
    end
  end
private
  
  #params for user creation
  def user_params
    params.require(:user).permit(:username, :email_address, :salt, :hashed_password)
  end

  #only allow access to the page/action if logged out
  def logout_required
    if current_user
      redirect_to current_user
    end
  end
  #only allow access to the page/action if logged in
  def login_required
    unless current_user
      redirect_to new_auth_path
    end
  end

  #only allow access to the page/action if user has admin privileges
  def admin_required
    unless is_admin?
      redirect_to root_path
    end
  end

  #only allow access to the page/action if either user has admin privileges or page belongs to logged in user
  def user_match_required
    @this_user = User.find(params[:id])
    unless ("#{current_user.id}" == "#{@this_user.id}") || (is_admin?)
      redirect_to root_path
    end
  end
end