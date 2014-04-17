require 'spec_helper'

describe 'tickets/new.html.slim' do
  let(:city) { tournament.city }
  let(:tournament) { create :tournament }
  let(:ticket) { build :ticket, tournament: tournament }
  before { assign :ticket, ticket }

  before { expect(view).to receive(:current_city).with(city) }

  before { render }

  subject { rendered }

  it { should_not have_selector %Q(.translation_missing) }

  it { should have_selector(%Q(#ticket h2.tournament), text: tournament.name) }

  specify 'the ticket form' do
    within %Q(#ticket form[action="#{tournament_tickets_path(tournament)}"][method="post"]) do |form|
      form.should have_selector %Q(input[name="ticket[email]"][value="#{ticket.email}"][type="email"])
      form.should have_selector %Q(input[name="ticket[nickname]"][value="#{ticket.nickname}"][type="text"])
      form.should have_selector %Q(input[type="submit"])
    end
  end
end
