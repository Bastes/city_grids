require 'spec_helper'

describe 'cities/show.html.slim' do
  let(:city) { create :city }
  before { create_list(:tournament, 3, city: city).map &:decorate }
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
            link.should have_selector %Q(.begins-on), text: I18n.l(tournament.begins_at.to_date, format: :long)
          end
          item.should have_selector %Q(a.address[href="#{tournament.address_url}"][target="_blank"]), text: tournament.address
          item.should have_selector %Q(.places), text: %r(\b#{tournament.places}\b)
        end
      end
    end
  end
end
