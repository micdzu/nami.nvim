# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :set_order, except: %i[index new create]

  NUMERALS = 1234567890
  SIMILAR = 'oO08 iIlL1 g9qCGQ 8%& <([{}])> .,;: ~-_='
  DIACRITICS_ETC = 'â é ù ï ø ç Ã Ē Æ œ'

  def index
    @orders = Order.all
  end

  def update
    if @order.update(order_params)
      flash[:notice] = 'Order was successfully updated.'
      redirect_to @order
    else
      render :action => 'edit'
    end
  end

  def destroy
    @order.destroy

    redirect_to orders_url
  end

  private

  def set_order
    @order = Order.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'Order not found'
    redirect_to orders_path
  end

  def order_params
    params.require(:order).permit(:name, :details)
  end
end

# adapted from https://github.com/FastArrow1019/RubyOnRails/
