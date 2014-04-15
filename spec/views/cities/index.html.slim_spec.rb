require 'spec_helper'

describe 'cities/index.html.slim' do
  context 'standard case' do
    let(:cities) { create_list :city, 3 }
    before { cities.each_with_index { |city, i| (-2..0).each { |j| create :tournament, city: city, begins_at: (i + j).days.from_now } } }
    before { cities.each &:reload }
    before { assign :cities, cities }

    before { render }

    subject { rendered }

    it { should_not have_selector(%Q(.translation_missing)) }

    specify 'the cities list' do
      within '#cities ul.cities' do |cities_list|
        cities.each_with_index do |city, i|
          within cities_list, %Q(> li:nth-child(#{i + 1})) do |city_item|
            city_item.should have_selector %Q(h2 a[href="#{view.city_path(city)}"]), text: city.name
            if city.incoming_tournaments.count == 0
              city_item.should_not have_selector %Q(ul.incoming_tournaments)
            else
              within city_item, %Q(ul.tournaments) do |tournaments_list|
                tournaments_list.should have_selector %Q(li), count: city.incoming_tournaments.count
                city.incoming_tournaments.each_with_index do |tournament, j|
                  within tournaments_list, %Q(li:nth-child(#{j + 1})) do |tournament_item|
                    tournament_item.should have_selector %Q(.begins-on), text: I18n.l(tournament.begins_at.to_date)
                    tournament_item.should have_selector %Q(.name), text: tournament.name
                  end
                end
              end
            end
          end
        end
        cities_list.should have_selector(%Q(li:last-child a[href="#{new_city_path}"]))
      end
    end
  end

  context 'too many incoming tournaments for a city' do
    let(:city) { create :city }
    before { [1,5,7,3,4,0].each { |n| create :tournament, city: city, begins_at: n.days.from_now } }
    before { city.reload }
    before { assign :cities, [city] }

    before { render }

    subject { rendered }

    it { should_not have_selector(%Q(.translation_missing)) }

    specify 'the tournaments list' do
      within '#cities ul.cities li ul.tournaments:first' do |tournaments_list|
        tournaments_list.should have_selector %Q(li), count: 4
        city.incoming_tournaments.take(3).each_with_index do |tournament, j|
          within tournaments_list, %Q(li:nth-child(#{j + 1})) do |tournament_item|
            tournament_item.should have_selector %Q(.begins-on), text: I18n.l(tournament.begins_at.to_date)
            tournament_item.should have_selector %Q(.name), text: tournament.name
          end
          tournaments_list.should have_selector %Q(li:nth-child(4) a[href="#{view.city_path(city)}"]), text: city.incoming_tournaments.count - 3
        end
      end
    end
  end
end
