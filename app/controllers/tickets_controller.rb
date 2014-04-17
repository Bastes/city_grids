class TicketsController < ApplicationController
  responders :flash

  def new
    @ticket = Ticket.new tournament_id: params[:tournament_id]
  end

  def create
    @ticket = Ticket.create permitted_params
    TicketMailer.activation(@ticket).deliver if @ticket.valid?
    respond_with @ticket, location: tournament
  end

  def activate
    ticket = Ticket.find params[:id]
    if ticket.admin == params[:a]
      ticket.update_attributes status: 'present'
      flash[:notice] = I18n.t 'flash.tickets.activate.notice'
      redirect_to ticket.tournament
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def forfeit
    ticket = Ticket.find params[:id]
    if ticket.admin == params[:a]
      ticket.update_attributes status: 'forfeit'
      flash[:notice] = I18n.t 'flash.tickets.forfeit.notice'
      redirect_to ticket.tournament
    else
      raise ActionController::RoutingError.new('Not Found')
    end
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
