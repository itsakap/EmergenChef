class OrdersController < ApplicationController
  before_action :set_order_and_user, only: [:show, :alert, :edit, :update, :destroy]
  before_action :set_user_only, only: [:new, :create]
  before_action :login_required

  #orders are predicated on user page, which is predicated on params; page can only be accessed by admin or by matching current_user
  def index
    @user = User.find(params[:user_id])
    @orders = User.find(params[:user_id]).orders
  end

  #action for declaring a new order's attributes
  def new
    @order = Order.new

  end

  #action for showing an order's details
  def show
  end

  #action for creating a new order
  def create
    #set order and user differs slightly from majority of actions
    @order = Order.new(order_params)
    if @order.save
      @this_user.orders.push(@order)
      redirect_to @this_user, notice: "Order saved"
    else
      render action: 'new'
    end
  end

  #action for e-mailing an order to the EmergenChef
  def alert
    Confirmer.delay.emergency(@order.id, @this_user.id)
    redirect_to @this_user
    flash[:notice] = "Email on route!"
  end

  #action for editing an order
  def edit
  end

  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @this_user, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order.destroy
    redirect_to @this_user
  end

  private
    def set_order_and_user
      @order = Order.find(params[:id]) #order id, not user id
      @this_user = User.find(params[:user_id])
    end

    def set_user_only
      @this_user = User.find(params[:user_id])
    end

    def order_params
      params.require(:order).permit(:name, :party_size, :dietary_preferences, :address, :emergency_date, :reason_for_event)
    end
    
    def login_required
      unless current_user
        redirect_to new_auth_path
      end
    end
end
