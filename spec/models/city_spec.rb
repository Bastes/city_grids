require 'spec_helper'

describe City do
  describe 'associations' do
    it { should have_many(:tournaments).dependent(:destroy) }

    describe '#incoming_tournaments' do
      subject(:city) { create :city }
      let!(:incoming_tournaments) { [2, 7, 1].map { |n| create :tournament, begins_at: n.days.from_now, city: city } }
      before { create_list :tournament, 2, :awaiting_activation, city: city }
      before { create_list :tournament, 2, :passed, city: city }
      before { create_list :tournament, 2, city: create(:city) }

      its(:incoming_tournaments) { should eq incoming_tournaments.sort_by(&:begins_at) }
    end
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }

    it { should_not allow_value('Really-does_idLook@likeanemail-toyou?').for(:email) }
    it { should allow_value('Well-Duh.yes@does.com').for(:email) }
  end

  describe 'scopes' do
    describe '.activated' do
      let!(:activated_cities) { create_list :city, 3, :activated }
      before { create_list :city, 2, :pending }

      it { expect(City.activated).to match_array activated_cities }
    end
  end

  describe '.find_by_name' do
    let(:cities) { create_list :city, 3 }
    let(:city) { cities.sample }

    it { expect(City.find_by_name(city.name)).to eq city }
    it { expect(City.find_by_name(city.name.downcase)).to eq city }
    it { expect(City.find_by_name(city.name.upcase)).to eq city }
    it { expect(City.find_by_name(cities.map(&:name).inject(&:+))).to be_nil }
  end

  it_behaves_like 'it generates automatically an admin token', with_hash_base: ->(instance, now) { "#{instance.name}#{now}" }
end
