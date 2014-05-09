require 'spec_helper'

describe 'tournaments/show.html.slim' do
  let(:raw_tournament) { create :tournament }
  let!(:present_tickets) { create_list :ticket, rand(1..5), :present, tournament: raw_tournament }
  let!(:pending_tickets) { create_list :ticket, rand(1..5), :pending, tournament: raw_tournament }
  let!(:forfeit_tickets) { create_list :ticket, rand(1..5), :forfeit, tournament: raw_tournament }
  let(:tournament) { raw_tournament.reload.decorate }
  let(:city)       { tournament.city }
  before { assign :tournament, tournament }

  let(:admin) { false }
  before { allow(view).to receive(:admin?).and_return(admin) }
  before { expect(view).to receive(:current_city).with(city) }

  before { render }

  subject { rendered }

  it { should_not have_selector(%Q(.translation_missing)) }

  specify 'the tournament itself' do
    within %Q(#tournament) do |item|
      item.should have_selector %Q(h2), text: tournament.name
      within item, %Q(.itself) do |itself|
        itself.should have_selector %Q(.organizer a[href="#{tournament.organizer_url}"]), text: tournament.organizer_nickname
        itself.should have_selector %Q(.timeframe .begins-at), text: I18n.l(tournament.begins_at, format: :long).capitalize
        itself.should have_selector %Q(.timeframe .ends-at), text: I18n.l(tournament.ends_at, format: :time_of_day)
        itself.should have_selector %Q(a.address[href="#{tournament.address_url}"][target="_blank"]), text: tournament.address
        itself.should have_selector %Q(a.address_map[href="#{tournament.address_url}"][target="_blank"] img[src="#{tournament.address_map_url}"])
        itself.should have_selector %Q(.abstract), text: tournament.abstract
      end
    end
  end

  specify 'the tickets list' do
    within %Q(#tournament .participants .present) do |item|
      item.should have_selector %Q(h3 .places .all),   text: tournament.places
      item.should have_selector %Q(h3 .places .taken), text: present_tickets.count
      within item, %Q(ul.tickets) do |list|
        list.should have_selector %Q(li), count: present_tickets.count
        tournament.tickets.present.each_with_index do |ticket, index|
          list.should have_selector %Q(li:nth-child(#{index + 1})), text: ticket.nickname
        end
      end
      item.should have_selector %Q(a[href="#{new_tournament_ticket_path(tournament)}"])
    end
  end

  context 'the tournament has no organizer_url' do
    let(:tournament) { create(:tournament, :urlless).decorate }

    it { should_not have_selector %Q(.organizer a) }
    it { should have_selector %Q(.organizer), text: tournament.organizer_nickname }
  end

  context 'the tournament has no ends_at' do
    let(:tournament) { create(:tournament, :endless).decorate }

    it { should_not have_selector %Q(#tournament .timeframe .ends_at) }
  end

  context 'the tournament has no places' do
    let(:tournament) { create(:tournament, :placesless).decorate }

    it { should_not have_selector %Q(#tournament h3 .places .all) }
  end

  context 'no participants (yet)' do
    let!(:present_tickets) { nil }

    context 'the tournament is active' do
      it { should_not have_selector %(#tournament .participants .present ul.tickets) }
      it { should have_selector %(#tournament .participants .present .be-the-first) }
    end

    context 'the tournament is over' do
      let(:tournament) { create(:tournament, :passed).decorate }

      it { should_not have_selector %(#tournament .participants .present ul.tickets) }
      it { should_not have_selector %(#tournament .participants .present .be-the-first) }
    end
  end

  context 'the tournament is over' do
    let(:tournament) { create(:tournament, :passed).decorate }

    it { should_not have_selector %Q(#tournament a[href="#{new_tournament_ticket_path(tournament)}"]) }
  end

  describe 'admin controls' do
    context 'admin' do
      let(:admin) { true }

      it { should have_selector %Q(#tournament a[href="#{edit_tournament_path(tournament, a: tournament.admin)}"]) }

      describe 'the bb code controls' do
        it { should have_selector %Q(#tournament a.bb[href="#bb"]) }
        it { should have_selector %Q(#tournament #tournament-bb) }
      end

      describe  'the forfeit tickets list' do
        context 'with forfeits' do
          specify do
            within %Q(#tournament .participants .forfeits) do |item|
              item.should have_selector %Q(h3), text: I18n.t('tournaments.show.forfeits', count: forfeit_tickets.count)
              within item, %Q(ul.tickets) do |list|
                list.should have_selector %Q(li), count: forfeit_tickets.count
                tournament.tickets.forfeit.each_with_index do |ticket, index|
                  list.should have_selector %Q(li:nth-child(#{index + 1})), text: ticket.nickname
                end
              end
            end
          end
        end

        context 'without forfeit' do
          let!(:forfeit_tickets) { [] }

          it { should_not have_selector %Q(#tournament .participants .forfeits)  }
        end
      end
    end

    context 'visitor' do
      let(:admin) { false }

      describe 'the bb code controls' do
        it { should_not have_selector %Q(#tournament a.bb) }
        it { should_not have_selector %Q(#tournament #tournament-bb) }
      end

      it { should_not have_selector %Q(#tournament a[href="#{edit_tournament_path(tournament, a: tournament.admin)}"]) }
      it { should_not have_selector %Q(#tournament .participants .forfeits) }
    end
  end
end
