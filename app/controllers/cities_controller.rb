class CitiesController < ApplicationController
  responders :flash

  def index
    @cities = City.includes(:incoming_tournaments).order(name: :asc)
  end

  def show
    @city = City.find params[:id]
  end

  def new
    @city = City.new
  end

  def create
    @city = City.create permitted_params
    respond_with @city
  end

  private

  def permitted_params
    params.require(:city).permit(:name)
  end
end
