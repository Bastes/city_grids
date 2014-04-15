class TicketsController < ApplicationController
  responders :flash

  def new
    @ticket = Ticket.new tournament_id: params[:tournament_id]
  end

  def create
    @ticket = Ticket.create permitted_params
    respond_with @ticket, location: tournament
  end

  private

  def tournament
    Tournament.find params.require :tournament_id
  end

  def permitted_params
    params.require(:ticket).
      permit(:email, :nickname).
      merge(tournament: tournament)
  end
end
