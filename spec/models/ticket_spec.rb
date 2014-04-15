require 'spec_helper'

describe Ticket do
  describe 'associations' do
    it { should belong_to :tournament }
  end

  describe 'validations' do
    it { should validate_presence_of :tournament }
    it { should validate_presence_of :nickname }
    it { should validate_uniqueness_of(:nickname).scoped_to(:tournament_id) }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of(:email).scoped_to(:tournament_id) }

    it { should_not allow_value('sorry bro not@an.email -srsly').for(:email) }
    it { should allow_value('yep.this-is@more_like.it').for(:email) }
  end
end
