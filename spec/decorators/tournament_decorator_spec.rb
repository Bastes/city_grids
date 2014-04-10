require 'spec_helper'

describe TournamentDecorator do
  subject { TournamentDecorator.new(tournament) }

  describe '#address_url' do
    let(:tournament) { build :tournament, address: %Q( \n 221 Baker & Street ? ) }

    its(:address_url) { should eq "https://maps.google.fr/maps?q=221+Baker+Street" }
  end
end
