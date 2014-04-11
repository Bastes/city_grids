require 'spec_helper'

describe City do
  describe 'associations' do
    it { should have_many :tournaments }

    describe '#incoming_tournaments' do
      subject(:city) { create :city }
      let!(:incoming_tournaments) { 3.times.map { |n| create :tournament, begins_at: n.days.from_now, city: city } }
      before { 2.times { |n| create :tournament, begins_at: (n + 1).days.ago, city: city } }
      before { 2.times { |n| create :tournament, begins_at: n.days.from_now, city: create(:city) } }

      its(:incoming_tournaments) { should match_array incoming_tournaments }
    end
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of(:name).case_insensitive }
  end
end
