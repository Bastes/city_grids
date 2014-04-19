class CityMailer < ActionMailer::Base
  default from: 'no-reply@netrunner-tournaments.fr'

  def activation city
    @city = city
    mail to: city.email, subject: I18n.t('city_mailer.activation.subject', name: city.name) do |format|
      format.html { render layout: 'outgoing_email' }
      format.text
    end
  end
end
