class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  def index
    @orders = current_user.orders
  end

  def new
    @order   = Order.new
  end

  def show
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      current_user.orders.push(@order)
      redirect_to current_user, notice: "Order saved"
    else
      render action: 'new'
    end
  end

  def alert
    @order = Order.find(params[:id])
    Confirmer.delay.emergency(@order.id, current_user.id)
    redirect_to current_user
    flash[:notice] = "Email on route!"
  end

  def edit
  end

  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to current_user, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order.destroy
    redirect_to current_user
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end
    def order_params
      params.require(:order).permit(:name, :party_size, :dietary_preferences, :address, :emergency_date, :reason_for_event)
    end
    def check_login
      unless current_user
        redirect_to new_auth_path
      end
    end
end
