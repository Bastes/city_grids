class TicketMailer < ActionMailer::Base
  default from: 'no-reply@netrunner-tournaments.fr'

  def activation ticket
    @ticket = ticket
    mail to: ticket.email, subject: I18n.t('tournament_mailer.activation.subject', date: I18n.l(ticket.tournament.begins_at.to_date, format: :long), name: ticket.tournament.name) do |format|
      format.html { render layout: 'outgoing_email' }
      format.text
    end
  end
end
