require 'spec_helper'

describe 'cities/show.html.slim' do
  let(:city) { create :city }
  let!(:tournaments) { create_list(:tournament, 3, city: city) }
  let!(:tickets) { tournaments.inject([]) { |r, tournament| r + create_list(:ticket, rand(1..5), tournament: tournament) } }
  before { assign :city, city.reload }

  before { expect(view).to receive(:current_city).with(city) }

  before { render }

  subject { rendered }

  it { should_not have_selector(%Q(.translation_missing)) }

  it { should have_selector(%Q(#city h2), text: city.name) }
  it { should have_selector(%Q(#city .new-tournament a[href="#{new_city_tournament_path(city)}"])) }

  specify 'incoming tournaments' do
    within '#city .tournaments ul' do |list|
      city.incoming_tournaments.decorate.each_with_index do |tournament, i|
        within list, %Q(li:nth-child(#{i + 1})) do |item|
          within item, %Q(h4 a[href="#{tournament_path(tournament)}"]) do |link|
            link.should have_selector %Q(.name), text: tournament.name
            link.should have_selector %Q(.begins-on), text: I18n.l(tournament.begins_at.to_date)
          end
          item.should have_selector %Q(a.address[href="#{tournament.address_url}"][target="_blank"]), text: tournament.address
          item.should have_selector %Q(.places .all),   text: I18n.t('cities.show.places.all', count: tournament.places)
          item.should have_selector %Q(.places .taken), text: I18n.t('cities.show.places.taken', count: tournament.tickets.present.count)
        end
      end
    end
  end

  context 'a tournament has no places' do
    let!(:tournaments) { create_list(:tournament, 1, city: city, places: nil) }

    it { should_not have_selector %Q(#city .tournaments ul li .places .all) }
  end

  context 'a tournament has no places taken' do
    let!(:tournaments) { create_list(:tournament, 1, city: city) }
    let!(:tickets) { [] }

    it { should_not have_selector %Q(#city .tournaments ul li .places .taken) }
  end
end
