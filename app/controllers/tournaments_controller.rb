class TournamentsController < ApplicationController
  responders :flash

  def new
    @tournament = Tournament.new city_id: params[:city_id]
  end

  def create
    @tournament = Tournament.create permitted_params
    TournamentMailer.activation(@tournament).deliver if @tournament.valid?
    respond_with @tournament, location: city
  end

  def activate
    tournament = Tournament.find(params[:id])
    if tournament.admin == params[:a]
      tournament.update_attributes activated: true
      flash[:notice] = I18n.t 'flash.tournaments.activate.notice'
      redirect_to tournament.city
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  private

  def city
    City.find params.require :city_id
  end

  def permitted_params
    params.require(:tournament).permit(*%i(organizer_email organizer_alias name address begins_at ends_at places abstract)).merge(city: city)
  end
end
