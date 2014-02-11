class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  def index
    if current_user
      @orders = current_user.orders
    else
      redirect_to new_auth_path
    end
  end

  def new
    if current_user
      @order = Order.new
    else
      redirect_to new_auth_path
    end
  end

  def show
    unless current_user
      redirect_to new_auth_path
    end
  end

  def create
    if current_user
      @order = Order.new(order_params)
      if @order.save
        current_user.orders.push(@order)
        redirect_to orders_path, notice: "Order saved"
      else
        render action: 'new'
      end
    else
      redirect_to new_auth_path
    end
  end

  def edit
    unless current_user
      redirect_to new_auth_path
    end
  end

  def update
    if current_user
      respond_to do |format|
        if @order.update(order_params)
          format.html { redirect_to @order, notice: 'Order was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @order.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to new_auth_path
    end
  end

  def destroy
    if current_user
      @order.destroy
      redirect_to orders_path
    else redirect_to new_auth_path
    end
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end
    def order_params
      params.require(:order).permit(:party_size, :dietary_preferences, :address, :emergency_date, :reason_for_event)
    end
end