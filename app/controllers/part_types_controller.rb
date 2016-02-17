class PartTypesController < ApplicationController
  before_action :set_part_type, only: [:show, :edit, :update]

  def index
    @part_types = PartType.all
    @page_name = "Типи частин"
    @link_to_new = new_part_type_path
  end

  def show
  end

  def new
    @part_type = PartType.new
    @page_name = "Новий тип"
  end

  def edit
    @page_name = "Редагуємо тип"
  end

  def create
    @part_type = PartType.new(part_type_params)

    respond_to do |format|
      if @part_type.save
        format.html { redirect_to action: "index", notice: 'PartType was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @part_type.update(part_type_params)
        format.html { redirect_to action: "index", notice: 'PartType was successfully updated.' }
      else
        format.html { render :edit }
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
