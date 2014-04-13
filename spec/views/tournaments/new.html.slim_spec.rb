require 'spec_helper'

describe 'tournaments/new.html.slim' do
  let(:city)       { create :city }
  let(:tournament) { build :tournament, city: city }
  before { assign :tournament, tournament }

  before { render }

  subject { rendered }

  it { should_not have_selector %Q(.translation_missing) }

  describe 'the city' do
    it { should have_selector(%Q(#city .city h2), text: city.name) }
  end

  specify 'the tournament form' do
    within %Q(#city form[action="#{view.city_tournaments_path(city)}"][method="post"]) do |form|
      form.should have_selector %Q(input[name="tournament[organizer_email]"][value="#{tournament.organizer_email}"][type="email"])
      form.should have_selector %Q(input[name="tournament[organizer_alias]"][value="#{tournament.organizer_alias}"][type="text"])

      form.should have_selector %Q(input[name="tournament[name]"][value="#{tournament.name}"][type="text"])
      form.should have_selector %Q(input[name="tournament[address]"][value="#{tournament.address}"][type="text"])
      form.should have_selector %Q(input[name="tournament[begins_at]"][value="#{I18n.l tournament.begins_at}"][type="datetime-local"])
      form.should have_selector %Q(input[name="tournament[ends_at]"][value="#{I18n.l tournament.ends_at}"][type="datetime-local"])
      form.should have_selector %Q(input[name="tournament[places]"][value="#{tournament.places}"][type="number"])
      form.should have_selector %Q(textarea[name="tournament[abstract]"]), text: tournament.abstract
      form.should have_selector %Q(input[type="submit"])
    end
  end
end
