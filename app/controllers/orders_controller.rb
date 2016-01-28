class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

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
    @order = Order.new
  end

  def edit
    @already_ord_parts = {}
    show_already_ordered_parts
  end

  def create
    params[:order][:return_date] = set_return_date
    @order = Order.new(order_params)

    decode_and_create_new_ordered_parts_for_order

    respond_to do |format|
      if @order.save && params[:sel_parts] != ""
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

    @already_ord_parts = {}
    show_already_ordered_parts

    @order.ordered_parts.destroy_all

    decode_and_create_new_ordered_parts_for_order

    respond_to do |format|
      if @order.update(order_params) && params[:sel_parts] != ""
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
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
    # Make return date base on selected date + number of days for rent
    date = Date.new order_params["date(1i)"].to_i, order_params["date(2i)"].to_i, order_params["date(3i)"].to_i
    new_date = date + order_params[:days_in_rent].to_i.days
    new_date
  end

  def show_already_ordered_parts
    # Shows already ordered parts for selected order
    ordered_parts = @order.ordered_parts.map {|i| [PartType.find(Part.find(i.ordered_part_id).part_type_id).type_name,
                                                   i.ordered_part_id.to_s + ' ' + Part.find(i.ordered_part_id).name + ' ' + Part.find(i.ordered_part_id).description]}
    ordered_parts.each {|k,v| @already_ord_parts.has_key?(k) ? @already_ord_parts[k] << v : @already_ord_parts[k] = [v]}
  end

  def decode_and_create_new_ordered_parts_for_order
    # Decode selected parts for order and create corresponding records
    # in ordered_parts
    if params[:sel_parts] != ""
      part_ids = ActiveSupport::JSON.decode(params[:sel_parts]).map {|p| p.split(' ')[0]}
      part_ids.each {|p| @order.ordered_parts.new(ordered_part_id: p)}
    end
  end

end
