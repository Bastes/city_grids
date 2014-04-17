require 'spec_helper'

describe 'tournaments/new.html.slim' do
  let(:city)       { create :city }
  let(:tournament) { build :tournament, city: city }
  before { assign :tournament, tournament }

  before { expect(view).to receive(:current_city).with(city) }

  before { render }

  subject { rendered }

  it { should_not have_selector %Q(.translation_missing) }

  it { should have_selector(%Q(#tournament h2.city), text: city.name) }

  specify 'the tournament form' do
    within %Q(#tournament form[action="#{city_tournaments_path(city)}"][method="post"]) do |form|
      form.should have_selector %Q(input[name="tournament[organizer_email]"][value="#{tournament.organizer_email}"][type="email"])
      form.should have_selector %Q(input[name="tournament[organizer_nickname]"][value="#{tournament.organizer_nickname}"][type="text"])

      form.should have_selector %Q(input[name="tournament[name]"][value="#{tournament.name}"][type="text"])
      form.should have_selector %Q(input[name="tournament[address]"][value="#{tournament.address}"][type="text"])
      form.should have_selector %Q(input[name="tournament[begins_at_date]"][value="#{I18n.l tournament.begins_at, format: '%Y-%m-%d'}"][type="date"])
      form.should have_selector %Q(input[name="tournament[begins_at_time]"][value="#{I18n.l tournament.begins_at, format: '%H:%M'}"][type="time"])
      form.should have_selector %Q(input[name="tournament[ends_at_time]"][value="#{I18n.l tournament.ends_at, format: '%H:%M'}"][type="time"])
      form.should have_selector %Q(input[name="tournament[places]"][value="#{tournament.places}"][type="number"])
      form.should have_selector %Q(textarea[name="tournament[abstract]"]), text: tournament.abstract
      form.should have_selector %Q(input[type="submit"])
    end
  end
end
