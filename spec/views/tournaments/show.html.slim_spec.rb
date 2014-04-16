require 'spec_helper'

describe 'tournaments/show.html.slim' do
  let(:tournament) { create(:tournament).decorate }
  let(:city)       { tournament.city }
  before { assign :tournament, tournament }

  before { render }

  subject { rendered }

  it { should_not have_selector(%Q(.translation_missing)) }

  describe 'the city' do
    it { should have_selector(%Q(#tournament .city h2 a[href="#{city_path(city)}"]), text: city.name) }
  end

  specify 'the tournament itself' do
    within %Q(#tournament .tournament) do |item|
      item.should have_selector %Q(h3), text: tournament.name
      item.should have_selector %Q(.organizer), text: tournament.organizer_nickname
      item.should have_selector %Q(.timeframe .begins-at), text: I18n.l(tournament.begins_at, format: :long)
      item.should have_selector %Q(.timeframe .ends-at), text: I18n.l(tournament.ends_at, format: :time_of_day)
      item.should have_selector %Q(a.address[href="#{tournament.address_url}"][target="_blank"]), text: tournament.address
      item.should have_selector %Q(.abstract), text: tournament.abstract
      item.should have_selector %Q(.places), text: tournament.places

      item.should have_selector %Q(a[href="#{new_tournament_ticket_path(tournament)}"])
    end
  end

  context 'the tournament has no ends_at' do
    let(:tournament) { create(:tournament, :endless).decorate }

    it { should_not have_selector %Q(#tournament .tournament .timeframe .ends_at) }
  end

  context 'the tournament has no places' do
    let(:tournament) { create(:tournament, :placesless).decorate }

    it { should_not have_selector %Q(#tournament .tournament .places) }
  end

  context 'the tournament is over' do
    let(:tournament) { create(:tournament, :passed).decorate }

    it { should_not have_selector %Q(#tournament .tournament a[href="#{new_tournament_ticket_path(tournament)}"]) }
  end
end
