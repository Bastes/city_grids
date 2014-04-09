require 'spec_helper'

describe 'cities/index.html.slim' do
  let(:cities) { create_list :city, 3 }
  before { assign :cities, cities }

  before { render }

  specify 'the cities list' do
    within 'ul#cities' do |list|
      cities.each_with_index do |city, i|
        list.should have_selector %Q(li:nth-child(#{i + 1})), text: city.name
      end
    end
  end
end
