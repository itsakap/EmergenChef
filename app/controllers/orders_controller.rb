class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  def index
    if current_user
      @orders = current_user.orders
    end
  end

  def new
    @order = Order.new
  end

  def show
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      current_user.orders.push(@order)
      redirect_to orders_path, notice: "Order saved"
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_path
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end
    def order_params
      params.require(:order).permit(:party_size, :dietary_preferences, :address, :emergency_date, :reason_for_event)
    end
end
