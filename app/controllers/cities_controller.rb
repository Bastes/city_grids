class CitiesController < ApplicationController
  def index
    @cities = City.includes(:incoming_tournaments).order(name: :asc)
  end

  def show
    @city = City.find params[:id]
  end
end
