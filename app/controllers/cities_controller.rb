class CitiesController < ApplicationController
  def index
    @cities = City.includes(:incoming_tournaments).order(name: :asc)
  end

  def show
    @city = City.find params[:id]
    @incoming_tournaments = @city.tournaments.incoming.ordered.decorate
  end
end
