require 'spec_helper'

describe ApplicationHelper do
  describe '#current_city' do
    context 'no current city specified' do
      it { expect(current_city).to be_nil }
    end

    context 'current city specified' do
      let(:city) { create :city }

      before { current_city city }

      it { expect(current_city).to eq city }
    end
  end
end
