class TournamentsController < ApplicationController
  responders :flash

  def show
    @tournament ||= tournament.decorate
  end

  def new
    @tournament = Tournament.new city_id: params[:city_id]
  end

  def edit
    redirect_to tournament unless admin?
  end

  def create
    @tournament = Tournament.create permitted_params
    TournamentMailer.activation(@tournament).deliver if @tournament.valid?
    respond_with @tournament, location: city
  end

  def update
    if admin?
      tournament.update_attributes permitted_update_params
      respond_with tournament, location: tournament_path(tournament, a: tournament.admin)
    else
      redirect_to tournament
    end
  end

  def activate
    if admin?
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

  protected

  helper_method def tournament
    @tournament ||= Tournament.find params[:id]
  end

  helper_method def admin?
    tournament.admin == params[:a]
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

  def permitted_update_params
    params.require(:tournament).
      permit(*%i(organizer_email organizer_nickname name address places abstract)).
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
