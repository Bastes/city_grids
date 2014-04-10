require 'spec_helper'

describe CitiesController do
  describe "GET 'index'" do
    let!(:cities) { create_list(:city, 3).sort_by &:name }
    before { get 'index' }

    it { expect(response).to be_success }
    it { expect(assigns[:cities]).to eq cities }
  end

  describe "GET 'show'" do
    let!(:cities) { create_list :city, 3 }
    let(:city) { cities.sample }
    let!(:incoming_tournaments) { [3, 4, 0].map { |n| create :tournament, begins_at: n.days.from_now, city: city }.sort_by(&:begins_at) }
    before { create :tournament, begins_at: 1.day.ago, city: city }
    before { create :tournament, begins_at: 1.day.from_now, city: (cities - [city]).sample }

    before { get 'show', id: city.id }

    it { expect(response).to be_success }
    it { expect(assigns[:city]).to eq city }
    it { expect(assigns[:incoming_tournaments]).to eq incoming_tournaments }
  end
end
