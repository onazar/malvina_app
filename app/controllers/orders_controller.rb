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
    @already_ord_parts = jsoned_already_ordered_parts
    @already_ord_parts_ids = jsoned_already_ordered_parts_ids
  end

  def create
    # Set from hidden tags because when element is disabled, rails doesn't send its value.
    params[:order][:date] = selected_date
    params[:order][:return_date] = set_return_date
    params[:order][:order_type] = params[:h_order_type]
    params[:order][:days_in_rent] = params[:h_days_in_rent]

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
    # Set from hidden tags because when element is disabled, rails doesn't send its value.
    params[:order][:date] = selected_date
    params[:order][:return_date] = set_return_date
    params[:order][:order_type] = params[:h_order_type]
    params[:order][:days_in_rent] = params[:h_days_in_rent]

    @already_ord_parts = jsoned_already_ordered_parts
    @already_ord_parts_ids = jsoned_already_ordered_parts_ids

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
    begin
      @order = Order.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url, :flash => { :notice => "Record not found in db. Please refresh page to make it up to date." }
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def order_params
    params.require(:order).permit(:date, :days_in_rent, :return_date, :order_params,
                                  :order_type, :name, :client_name, :client_phone, :tbd)
  end

  def selected_date
    # Make normal date YYYY-MM-DD.
    Date.new params[:h_date_year].to_i, params[:h_date_month].to_i, params[:h_date_day].to_i
  end

  def set_return_date
    # Make return date base on selected date + number of days for rent
    selected_date + params[:h_days_in_rent].to_i.days
  end

  def jsoned_already_ordered_parts
    # Returns already ordered parts for selected order as [].to_json
    @order.ordered_parts.map {|i| i.ordered_part_id.to_s + ' ' + Part.find(i.ordered_part_id).name + ' ' + Part.find(i.ordered_part_id).description}.to_json
  end

  def jsoned_already_ordered_parts_ids
    # Returns already ordered parts ids for selected order as [].to_json
    @order.ordered_parts.pluck(:ordered_part_id).to_json
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
