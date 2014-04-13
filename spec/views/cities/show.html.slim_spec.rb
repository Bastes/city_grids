require 'spec_helper'

describe 'cities/show.html.slim' do
  let(:city) { create :city }
  before { create_list(:tournament, 3, city: city).map &:decorate }
  before { assign :city, city.reload }

  before { render }

  subject { rendered }

  it { should_not have_selector(%Q(.translation_missing)) }

  describe 'the city' do
    it { should have_selector(%Q(#city .city h2), text: city.name) }
    it { should have_selector(%Q(#city .city a[href="#{view.new_city_tournament_path(city)}"])) }
  end

  specify 'incoming tournaments' do
    within '#city .tournaments ul' do |list|
      city.incoming_tournaments.decorate.each_with_index do |tournament, i|
        within list, %Q(li:nth-child(#{i + 1})) do |item|
          item.should have_selector %Q(h4 .name), text: tournament.name
          item.should have_selector %Q(h4 .begins-on), text: I18n.l(tournament.begins_at.to_date, format: :long)
          item.should have_selector %Q(a.address[href="#{tournament.address_url}"][target="_blank"]), text: tournament.address
          item.should have_selector %Q(.places), text: %r(\b#{tournament.places}\b)
        end
      end
    end
  end
end
