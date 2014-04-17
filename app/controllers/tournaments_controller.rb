class TournamentsController < ApplicationController
  responders :flash

  def show
    @tournament = Tournament.find(params[:id]).decorate
  end

  def new
    @tournament = Tournament.new city_id: params[:city_id]
  end

  def create
    @tournament = Tournament.create permitted_params
    TournamentMailer.activation(@tournament).deliver if @tournament.valid?
    respond_with @tournament, location: city
  end

  def activate
    tournament = Tournament.find params[:id]
    if tournament.admin == params[:a]
      unless tournament.activated
        tournament.update_attributes activated: true
        flash[:notice] = I18n.t 'flash.tournaments.activate.notice'
        TournamentMailer.administration(tournament).deliver
      end
      redirect_to tournament
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  private

  def city
    City.find params.require :city_id
  end

  def permitted_params
    params.require(:tournament).
      permit(*%i(organizer_email organizer_nickname name address places abstract)).
      merge(city: city).
      merge(begins_at: tournament_begins_at).
      merge(ends_at:   tournament_ends_at)
  end

  def tournament_begins_at
    if params[:tournament] && params[:tournament][:begins_at_date] && params[:tournament][:begins_at_time]
      "#{params[:tournament][:begins_at_date]} #{params[:tournament][:begins_at_time]}"
    end
  end

  def tournament_ends_at
    if params[:tournament] && params[:tournament][:begins_at_date] && params[:tournament][:ends_at_time]
      "#{params[:tournament][:begins_at_date]} #{params[:tournament][:ends_at_time]}"
    end
  end
end
