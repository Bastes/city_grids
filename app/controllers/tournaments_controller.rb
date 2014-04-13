class TournamentsController < ApplicationController
  responders :flash

  def new
    @tournament = Tournament.new city_id: params[:city_id]
  end

  def create
    @tournament = Tournament.create permitted_params
    respond_with @tournament, location: city
  end

  private

  def city
    City.find params.require :city_id
  end

  def permitted_params
    params.require(:tournament).permit(*%i(organizer_email organizer_alias name address begins_at ends_at places abstract)).merge(city: city)
  end
end
