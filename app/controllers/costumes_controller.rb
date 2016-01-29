class CostumesController < ApplicationController
  before_action :set_costume, only: [:show, :edit, :update]

  def index
    @costumes = Costume.all
  end

  def show
  end

  def new
    @costume = Costume.new
  end

  def edit
  end

  def costume_names
    cst_names = []
    puts "-----> #{params}"
    if params.has_key?(:name_pattern) and params[:name_pattern] != ""
      cst_names = Costume.where("name like ?", "%#{params[:name_pattern]}%").map {|n| n.name}
    end

    if params.has_key?(:id_pattern) and !(Integer(params[:id_pattern]) rescue nil).nil?
      begin
        cst_names = [Costume.find(params[:id_pattern].to_i).name]
      rescue ActiveRecord::RecordNotFound
        cst_names = []
      end
    end

    if request.xhr?
      render :json => { :cst_names => cst_names }
    end
  end

  def costume_parts
    puts "-----> #{params}"
    ord_date = make_normal_date
    ret_date = set_return_date
    puts "--ord_date---> #{ord_date}"
    puts "--ret_date---> #{ret_date}"

    # Schema how to guess if parts are booked for these dates
    # 26.01---------28.01     28.01-------------31.01
    #         27.01----------------------30.01  <----- Parts already booked for these dates
    #         27.01------28.01           30.01--31.01

    # Get order ids that match client dates
    order_ids = Order.where("date <= ? AND return_date > ? OR date < ? AND return_date >= ?",
                            ord_date, ord_date, ret_date, ret_date).pluck(:id)
    # Get booked parts for clients dates
    ordered_parts = order_ids.map { |oi| OrderedPart.where(order_id: oi).pluck(:ordered_part_id) }.flatten

    puts "--order_ids---> #{order_ids}"
    puts "--ordered_parts---> #{ordered_parts}"

    parts = {}
    if params[:costume_name]
      # Get costume id by its name
      cst_id = Costume.where(name: params[:costume_name]).pluck(:id)[0]

      # Get available costume parts for client dates and group them by part types.
      Costume.find(cst_id).parts.where("id NOT IN (?)", ordered_parts.empty? ? [0] : ordered_parts).group_by(&:part_type_id).each do |t_id, cst_prts|
        puts "--cst_prts---> #{cst_prts}"
        parts[PartType.find(t_id).type_name] = cst_prts.map {|p| p.id.to_s + ' ' + p.name + ' ' + p.description}
      end
    end

    if request.xhr?
      render :json => { :parts_for_costume => parts }
    end
  end

  def create
    @costume = Costume.new(costume_params)
    @parts = Part.where(:id => params[:costume_parts])
    @costume.parts << @parts

    respond_to do |format|
      if @costume.save
        format.html { redirect_to @costume, notice: 'Costume was successfully created.' }
        format.json { render :show, status: :created, location: @costume }
      else
        format.html { render :new }
        format.json { render json: @costume.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @parts = Part.where(:id => params[:costume_parts])
    @costume.parts.destroy_all
    @costume.parts << @parts

    respond_to do |format|
      if @costume.update(costume_params)
        format.html { redirect_to @costume, notice: 'Costume was successfully updated.' }
        format.json { render :show, status: :ok, location: @costume }
      else
        format.html { render :edit }
        format.json { render json: @costume.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_costume
    @costume = Costume.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def costume_params
    params.require(:costume).permit(:name, :description)
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
