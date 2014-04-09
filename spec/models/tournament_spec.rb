require 'spec_helper'

describe Tournament do
  describe 'associations' do
    it { should belong_to :city }
  end

  describe 'validations' do
    it { should validate_presence_of :city }
    it { should validate_presence_of :organizer_alias }
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
    end
  end
end
