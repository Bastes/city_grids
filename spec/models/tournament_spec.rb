require 'spec_helper'

describe Tournament do
  describe 'associations' do
    it { should belong_to :city }
  end

  describe 'validations' do
    it { should validate_presence_of :city }
    it { should validate_presence_of :organizer_nickname }
    it { should validate_presence_of :organizer_email }
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :begins_at }

    it { should_not allow_value('Something blatently not an email').for(:organizer_email) }
    it { should allow_value('Whatever.the-email_might01be@gmail-or-anything.blah').for(:organizer_email) }

    describe '#ends_at' do
      before { allow(subject).to receive(:begins_at).and_return { Time.now } }

      it { should allow_value(1.second.from_now).for(:ends_at) }
      it { should_not allow_value(1.second.ago).for(:ends_at) }
      it { should allow_value(nil).for(:ends_at) }
      it { should allow_value('').for(:ends_at) }
    end
  end

  describe 'scopes' do
    describe '#incoming' do
      let!(:incoming_tournaments) { create_list :tournament, 3, :incoming }
      before { create_list :tournament, 3, :passed }

      it { expect(Tournament.incoming).to match_array incoming_tournaments }
    end

    describe '#activated' do
      let!(:activated_tournaments) { create_list :tournament, 3, :activated }
      before { create_list :tournament, 3, :awaiting_activation }

      it { expect(Tournament.activated).to match_array activated_tournaments }
    end

    describe '#ordered' do
      let(:tournaments) { [1, -2, 4].map { |n| create :tournament, begins_at: n.days.from_now } }

      it { expect(Tournament.ordered).to eq tournaments.sort_by(&:begins_at) }
    end
  end

  describe 'pseudo-fields' do
    describe 'standard case (no blanks)' do
      subject(:tournament) { build :tournament }

      its(:begins_at_date) { should eq I18n.l(tournament.begins_at, format: '%Y-%m-%d') }
      its(:begins_at_time) { should eq I18n.l(tournament.begins_at, format: '%H:%M') }
      its(:ends_at_time)   { should eq I18n.l(tournament.ends_at,   format: '%H:%M') }
    end

    describe 'edge cases (blanks)' do
      {
        begins_at_date: :begins_at,
        begins_at_time: :begins_at,
        ends_at_time: :ends_at
      }.each do |field, real_field|
        describe "##{field}" do
          [nil, ''].each do |value|
            context "#{value.inspect}" do
              subject(:tournament) { Tournament.new real_field => value }

              its(field) { should eq nil }
            end
          end
        end
      end
    end
  end

  describe '#set_admin' do
    describe 'the method itself' do
      let(:now) { Time.now }
      let(:tournament) { build :tournament, admin: nil }

      before { allow(Digest::MD5).to receive(:new).and_return(double().tap { |d| allow(d).to receive(:update).with("#{tournament.name}#{now}").and_return('some hash') }) }
      before { Timecop.freeze(now) { tournament.set_admin } }
      subject { tournament }

      describe '#admin was empty' do
        let(:tournament) { build :tournament }

        its(:admin) { should eq 'some hash' }
      end

      describe 'admin was set' do
        let(:tournament) { build :tournament, admin: 'some other hash' }

        its(:admin) { should eq 'some other hash' }
      end
    end

    describe 'hooks' do
      let(:tournament) { build :tournament }
      subject { -> { tournament.save } }

      it { should change(tournament, :admin) }
    end
  end
end
