class PartsController < ApplicationController
  before_action :set_part, only: [:show, :edit, :update]

  def index
    @parts = Part.all
  end

  def show
  end

  def new
    @part = Part.new
  end

  def edit
  end

  def part_names
    ord_date = make_normal_date
    ret_date = set_return_date

    # Schema how to guess if parts are booked for these dates
    # 26.01---------28.01     28.01-------------31.01
    #         27.01----------------------30.01  <----- Parts already booked for these dates
    #         27.01------28.01           30.01--31.01

    # Get order ids that match client dates
    order_ids = Order.where("date <= ? AND return_date > ? OR date < ? AND return_date >= ?",
                            ord_date, ord_date, ret_date, ret_date).pluck(:id)
    # Get booked parts for clients dates
    ordered_parts = order_ids.map { |oi| OrderedPart.where(order_id: oi).pluck(:ordered_part_id) }.flatten

    # While edit/update existed order, we show already exists parts for user
    # in case he will remove them from selected list he can pick them up again,
    # because they will be available for this order.
    if params[:already_selected_parts_ids] != ""
      ordered_parts = ordered_parts - ActiveSupport::JSON.decode(params[:already_selected_parts_ids])
    end

    parts = {}
    if params.has_key?(:name_pattern) and params[:name_pattern] != ""
      # Get available parts by name pattern for client dates and group them by part types.
      Part.where("name LIKE ? AND id NOT IN (?)", "%#{params[:name_pattern]}%", ordered_parts.empty? ? [0] : ordered_parts).group_by(&:part_type_id).each do |t_id, prts|
        parts[PartType.find(t_id).type_name] = prts.map {|p| p.id.to_s + ' ' + p.name + ' ' + p.description}
      end
    elsif params.has_key?(:id_pattern) and !(Integer(params[:id_pattern]) rescue nil).nil?
      # Get available part by id pattern for client dates and return part type with part.
      begin
        if !ordered_parts.include? params[:id_pattern].to_i
            prt = Part.find(params[:id_pattern])
            parts[PartType.find(prt.part_type_id).type_name] = [prt.id.to_s + ' ' + prt.name + ' ' + prt.description]
        end
      rescue ActiveRecord::RecordNotFound
        parts = {}
      end
    end

    if request.xhr?
      render :json => { :available_parts => parts }
    end
  end


  def create
    @part = Part.new(part_params)

    respond_to do |format|
      if @part.save
        format.html { redirect_to @part, notice: 'Part was successfully created.' }
        format.json { render :show, status: :created, location: @part }
      else
        format.html { render :new }
        format.json { render json: @part.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @part.update(part_params)
        format.html { redirect_to @part, notice: 'Part was successfully updated.' }
        format.json { render :show, status: :ok, location: @part }
      else
        format.html { render :edit }
        format.json { render json: @part.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_part
    @part = Part.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def part_params
    params.require(:part).permit(:name, :description, :part_type_id)
  end

  def set_return_date
    # Make return date base on selected date + number of days for rent
    make_normal_date + params[:rent_days].to_i.days
  end

  def make_normal_date
    # Make normal date YYYY-MM-DD based on list ["YYYY", "M", "D"]
    Date.new params[:ord_date][0].to_i, params[:ord_date][1].to_i, params[:ord_date][2].to_i
  end

end
