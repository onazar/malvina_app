class PartTypesController < ApplicationController
  before_action :set_part_type, only: [:show, :edit, :update]

  def index
    @part_types = PartType.all
    @page_name = "Типи частин"
    @link_to_new = "/part_types/new"
  end

  def show
  end

  def new
    @part_type = PartType.new
  end

  def edit
  end

  def create
    @part_type = PartType.new(part_type_params)

    respond_to do |format|
      if @part_type.save
        format.html { redirect_to @part_type, notice: 'PartType was successfully created.' }
        format.json { render :show, status: :created, location: @part_type }
      else
        format.html { render :new }
        format.json { render json: @part_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @part_type.update(part_type_params)
        format.html { redirect_to @part_type, notice: 'PartType was successfully updated.' }
        format.json { render :show, status: :ok, location: @part_type }
      else
        format.html { render :edit }
        format.json { render json: @part_type.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_part_type
      @part_type = PartType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def part_type_params
      params.require(:part_type).permit(:type_name)
    end
end
