require 'spec_helper'

describe TournamentDecorator do
  subject { TournamentDecorator.new(tournament) }

  describe '#address_url' do
    let(:tournament) { build :tournament, address: %Q( \n 221 Baker & Street ? ) }

    its(:address_url) { should eq "https://maps.google.fr/maps?q=221+Baker+Street" }
  end

  describe '#address_map_url' do
    let(:tournament) { build :tournament, address: %Q( and now, for something ? completely & different \n) }

    its(:address_map_url) { should eq "http://maps.googleapis.com/maps/api/staticmap?zoom=15&sensor=false&size=620x140&markers=color:blue%7Cand+now,+for+something+completely+different" }
  end
end
