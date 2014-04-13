require 'spec_helper'

describe City do
  describe 'associations' do
    it { should have_many :tournaments }

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
    it { should validate_uniqueness_of(:name).case_insensitive }
  end
end
