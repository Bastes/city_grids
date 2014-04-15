require 'spec_helper'

describe 'tickets/new.html.slim' do
  let(:city) { tournament.city }
  let(:tournament) { create :tournament }
  let(:ticket) { build :ticket, tournament: tournament }
  before { assign :ticket, ticket }

  before { render }

  subject { rendered }

  it { should_not have_selector %Q(.translation_missing) }

  describe 'the city' do
    it { should have_selector(%Q(#city .city h2), text: city.name) }
    it { should have_selector(%Q(#city .city h3), text: tournament.name) }
  end

  specify 'the ticket form' do
    within %Q(#city form[action="#{tournament_tickets_path(tournament)}"][method="post"]) do |form|
      form.should have_selector %Q(input[name="ticket[email]"][value="#{ticket.email}"][type="email"])
      form.should have_selector %Q(input[name="ticket[nickname]"][value="#{ticket.nickname}"][type="text"])
      form.should have_selector %Q(input[type="submit"])
    end
  end
end
