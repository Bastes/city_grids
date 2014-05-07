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

  describe '#abstract_bb' do
    let(:tournament) { build :tournament, abstract: <<eos.strip }
Do you see any Teletubbies in here?

Do you see a slender plastic tag clipped to my shirt with my name printed on it? Do you see a little Asian <a href="http://blahblah.com" target="_blank">child</a> with a blank expression on his face sitting outside on a mechanical helicopter that shakes when you put quarters in it? http://www.somewhere.com No? Well, that's what you see at a toy store.
And you must <script>alert('Aaaargh!');</script>think you're in a toy store, because you're here shopping for an infant named Jeb.
eos

    its(:abstract_bb) { should eq <<eos.strip }
Do you see any Teletubbies in here?

Do you see a slender plastic tag clipped to my shirt with my name printed on it? Do you see a little Asian child with a blank expression on his face sitting outside on a mechanical helicopter that shakes when you put quarters in it? [url]http://www.somewhere.com[/url] No? Well, that's what you see at a toy store.
And you must think you're in a toy store, because you're here shopping for an infant named Jeb.
eos
  end
end
