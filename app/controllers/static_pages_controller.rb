class StaticPagesController < ApplicationController
  def home
    @orders = Order.all
    @date = params[:month] ? Date.strptime(params[:month], "%Y-%m") : Date.today
  end
end
