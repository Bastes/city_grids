class TournamentDecorator < Draper::Decorator
  delegate_all

  def address_url
    %Q(https://maps.google.fr/maps?q=#{address.gsub(/[&?]+/, ' ').strip.gsub(/\s+/, '+')})
  end
end
