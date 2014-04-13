class TournamentMailer < ActionMailer::Base
  default from: 'no-reply@netrunner-tournaments.fr'

  def activation tournament
    @tournament = tournament
    mail to: tournament.organizer_email, subject: I18n.t('tournament_mailer.activation.subject', date: I18n.l(tournament.begins_at.to_date, format: :long), name: tournament.name) do |format|
      format.html # { render layout: 'outgoing_email' }
      format.text
    end
  end
end
