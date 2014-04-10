require 'spec_helper'

describe 'cities/index.html.slim' do
  let(:cities) { create_list :city, 3 }
  before { assign :cities, cities }

  before { render }

  subject { rendered }

  it { should_not have_selector(%Q(.translation_missing)) }

  specify 'the cities list' do
    within '#cities ul' do |list|
      cities.each_with_index do |city, i|
        list.should have_selector %Q(li:nth-child(#{i + 1}) h2 a[href="#{view.city_path(city)}"]), text: city.name
      end
    end
  end
end
