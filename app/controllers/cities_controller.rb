class CitiesController < ApplicationController
  def index
    @cities = City.order(name: :asc)
  end

  def show
    @city = City.find params[:id]
    @incoming_tournaments = @city.tournaments.incoming.ordered.load
  end
end
