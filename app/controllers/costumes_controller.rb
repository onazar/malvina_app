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
end
