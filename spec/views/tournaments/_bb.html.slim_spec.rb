require 'spec_helper'

describe 'tournaments/_bb.html.slim' do
  let(:tournament) { create(:tournament).decorate }
  before { render partial: 'bb', locals: { tournament: tournament } }

  subject { rendered }

  it { should_not have_selector(%Q(.translation_missing)) }

  it { should have_selector %Q(#tournament-bb a.close-reveal-modal) }
  it { should have_selector %Q(#tournament-bb a.bb-copy[href="#bb-copy"]) }
  it { should have_selector %Q(#tournament-bb a[href="http://www.run4games.com/forum/viewforum.php?f=151&sid=48832f397a098ca0f3704f54e27867c2"][target="_blank"]) }

  describe 'the bb code' do
    context 'general case' do
      it { should have_selector %Q(#tournament-bb textarea), text: %r(\A\[b\]\[url=#{Regexp.escape(tournament_url(tournament))}\]#{Regexp.escape(tournament.name)}\[/url\]\[/b\]) }
      it { should have_selector %Q(#tournament-bb textarea), text: %Q(#{view.l(tournament.begins_at, format: :long).capitalize} - #{view.l(tournament.ends_at, format: :time_of_day)}) }
      it { should have_selector %Q(#tournament-bb textarea), text: %Q([url=#{tournament.organizer_url}]#{tournament.organizer_nickname}[/url]) }
      it { should have_selector %Q(#tournament-bb textarea), text: %Q([url=#{tournament.address_url}]#{tournament.address}[/url]) }
      it { should have_selector %Q(#tournament-bb textarea), text: %Q([url=#{tournament.address_url}][img]#{tournament.address_map_url}[/img][/url]) }
      it { should have_selector %Q(#tournament-bb textarea), text: tournament.abstract_bb }
      it { should have_selector %Q(#tournament-bb textarea), text: %r(\[b\]\[url=#{Regexp.escape(tournament_url(tournament))}\].*\[/url\]\[/b\]\Z) }
    end

    context 'no organizer url' do
      let(:tournament) { create(:tournament, organizer_url: nil).decorate }

      it { should_not have_selector %Q(#tournament-bb textarea), text: %Q([url=]#{tournament.organizer_nickname}[/url]) }
      it { should have_selector %Q(#tournament-bb textarea), text: tournament.organizer_nickname }
    end

    context 'no ends_at' do
      let(:tournament) { create(:tournament, :endless).decorate }

      it { should_not have_selector %Q(#tournament-bb textarea), text: %Q(#{view.l(tournament.begins_at, format: :long).capitalize} -) }
      it { should have_selector %Q(#tournament-bb textarea), text: view.l(tournament.begins_at, format: :long).capitalize }
    end
  end
end
