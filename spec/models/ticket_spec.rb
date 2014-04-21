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
    it { should validate_presence_of :status }
    it { should ensure_inclusion_of(:status).in_array(Ticket::STATUS_VALUES) }

    it { should_not allow_value('sorry bro not@an.email -srsly').for(:email) }
    it { should allow_value('yep.this-is@more_like.it').for(:email) }
  end

  describe 'scopes' do
    describe '#present' do
      let!(:present_tickets) { create_list :ticket, 3, :present }
      before { create_list :ticket, 2, :forfeit }
      before { create_list :ticket, 1, :pending }

      it { expect(Ticket.present).to match_array present_tickets }
    end

    describe '#forfeit' do
      let!(:forfeit_tickets) { create_list :ticket, 3, :forfeit }
      before { create_list :ticket, 2, :present }
      before { create_list :ticket, 1, :pending }

      it { expect(Ticket.forfeit).to match_array forfeit_tickets }
    end
  end

  describe '#initialize' do
    context 'status not explicitely set' do
      it { expect(Ticket.new.status).to eq 'pending' }
    end

    context 'status explicitely set' do
      it { expect(Ticket.new(status: 'present').status).to eq 'present' }
    end
  end

  it_behaves_like 'it generates automatically an admin token', with_hash_base: ->(instance, now) { "#{instance.nickname}#{now}" }
end
