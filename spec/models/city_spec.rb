require 'spec_helper'

describe City do
  describe 'associations' do
    it { should have_many :tournaments }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of(:name).case_insensitive }
  end
end
