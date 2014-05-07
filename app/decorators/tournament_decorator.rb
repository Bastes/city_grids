class TournamentDecorator < Draper::Decorator
  delegate_all

  def address_url
    %Q(https://maps.google.fr/maps?q=#{clean_address_for_google})
  end

  def address_map_url
    %Q(http://maps.googleapis.com/maps/api/staticmap?zoom=15&sensor=false&size=620x140&markers=color:blue%7C#{clean_address_for_google})
  end

  def abstract_bb
    h.auto_link(h.sanitize(abstract, tags: [])).gsub(%r(<a +href=['"](.+?)['"]>.+?</a>), '[url]\1[/url]')
  end

  protected

  def clean_address_for_google
    address.gsub(/[&?]+/, ' ').strip.gsub(/\s+/, '+')
  end
end
