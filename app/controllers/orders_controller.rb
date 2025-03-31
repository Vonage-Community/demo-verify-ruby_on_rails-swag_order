class OrdersController < ApplicationController
  def show
    @order = Order.find_by(uuid: params[:id])

    unless @order
      render 'orders/not_found', status: :not_found
      return 
    end
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(
      uuid: SecureRandom.uuid,
      **order_params
    )

    if @order.save
      redirect_to order_path(@order)
    else
      flash[:alert] = "There was a problem creating the order. Please try again."
      render :new
    end
  end

  private

  def order_params
    params.require(:order).permit(:product_name)
  end
end
