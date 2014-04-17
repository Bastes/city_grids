require 'spec_helper'

describe 'tournaments/show.html.slim' do
  let(:raw_tournament) { create :tournament }
  let!(:present_tickets) { create_list :ticket, 3, :present, tournament: raw_tournament }
  before { create_list :ticket, 2, :pending, tournament: raw_tournament }
  before { create_list :ticket, 1, :absent,  tournament: raw_tournament }
  let(:tournament) { raw_tournament.reload.decorate }
  let(:city)       { tournament.city }
  before { assign :tournament, tournament }

  let(:admin) { false }
  before { allow(view).to receive(:admin?).and_return(admin) }

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
      item.should have_selector %Q(a[href="#{new_tournament_ticket_path(tournament)}"])
    end
  end

  specify 'the tickets list' do
    within %Q(#tournament .tournament) do |item|
      item.should have_selector %Q(h4 .places .all),   text: tournament.places
      item.should have_selector %Q(h4 .places .taken), text: present_tickets.count
      within item, %Q(ul.tickets) do |list|
        list.should have_selector %Q(li), count: present_tickets.count
        tournament.tickets.present.each_with_index do |ticket, index|
          list.should have_selector %Q(li:nth-child(#{index + 1})), text: ticket.nickname
        end
      end
    end
  end

  context 'the tournament has no ends_at' do
    let(:tournament) { create(:tournament, :endless).decorate }

    it { should_not have_selector %Q(#tournament .tournament .timeframe .ends_at) }
  end

  context 'the tournament has no places' do
    let(:tournament) { create(:tournament, :placesless).decorate }

    it { should_not have_selector %Q(#tournament .tournament h4 .places .all) }
  end

  context 'no participants (yet)' do
    let!(:present_tickets) { nil }

    it { should_not have_selector %(#tournament .tournament ul.tickets) }
    it { should have_selector %(#tournament .tournament .be-the-first) }
  end

  context 'the tournament is over' do
    let(:tournament) { create(:tournament, :passed).decorate }

    it { should_not have_selector %Q(#tournament .tournament a[href="#{new_tournament_ticket_path(tournament)}"]) }
  end

  describe 'admin controls' do
    context 'admin' do
      let(:admin) { true }

      it { should have_selector %Q(#tournament .tournament a[href="#{edit_tournament_path(tournament, a: tournament.admin)}"]) }
    end

    context 'visitor' do
      let(:admin) { false }

      it { should_not have_selector %Q(#tournament .tournament a[href="#{edit_tournament_path(tournament, a: tournament.admin)}"]) }
    end
  end
end
