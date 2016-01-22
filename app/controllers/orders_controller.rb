class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update]

  def index
    @orders = Order.all
  end

  def show
  end

  def search
    @new_ord = false
    if params[:date] then
      @orders = Order.all.where(:date => params[:date])
      @action = "Orders for #{params[:date]}"
      @new_ord = true
    elsif params[:return_date] then
      @orders = Order.all.where(:return_date => params[:return_date])
      @action = "Returns for #{params[:return_date]}"
    end
  end

  def new
    @chosen_date = params[:chosen_date]
    puts "----> #{@chosen_date}"
    @order = Order.new
  end

  def edit
  end

  def create
    params[:order][:return_date] = set_return_date
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    params[:order][:return_date] = set_return_date
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def order_params
    params.require(:order).permit(:date, :days_in_rent, :return_date, :order_params, :order_type, :name, :client_name, :client_phone)
  end

  def set_return_date
    puts "here"
    date = Date.new order_params["date(1i)"].to_i, order_params["date(2i)"].to_i, order_params["date(3i)"].to_i
    new_date = date + order_params[:days_in_rent].to_i.days
    new_date
  end

end
