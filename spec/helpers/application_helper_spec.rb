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

  describe '#bb' do
    it { expect(bb(:b) { "Whatever inside" }).to eq "[b]Whatever inside[/b]" }
    it { expect(bb(:i) { "Something else" }).to  eq "[i]Something else[/i]" }
    it { expect(bb(:url, 'http://www.wherever.com') { "A label" }).to  eq %Q([url=http://www.wherever.com]A label[/url]) }
    it { expect(bb(:quote, 'The Dude') { "Abides" }).to  eq %Q([quote=The Dude]Abides[/quote]) }
  end
end
