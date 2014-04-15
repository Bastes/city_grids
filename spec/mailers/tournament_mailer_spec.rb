require "spec_helper"

describe TournamentMailer do
  describe "#activation" do
    let(:tournament) { create :tournament }
    subject(:mail) { TournamentMailer.activation tournament }

    its(:subject) { should match %r{#{Regexp.escape tournament.name}} }
    its(:subject) { should match %r{#{Regexp.escape I18n.l(tournament.begins_at.to_date, format: :long)}} }
    its(:to)      { should eq [tournament.organizer_email] }
    its(:from)    { should eq ['no-reply@netrunner-tournaments.fr'] }

    %w{plain html}.each do |part|
      describe "in #{part}" do
        subject { message_part mail, part }

        it { should match %r{#{Regexp.escape tournament.organizer_nickname}} }
        it { should match %r{#{Regexp.escape tournament.name}} }
        it { should match %r{#{Regexp.escape I18n.l(tournament.begins_at.to_date, format: :long)}} }
      end
    end

    describe 'in plain' do
      subject { message_part mail, 'plain' }

      it { should match %r(#{Regexp.escape activate_tournament_url(tournament, a: tournament.admin)}) }
    end

    describe 'in html' do
      subject { message_part mail, 'html' }

      it { should have_selector %Q(a[href="#{activate_tournament_url(tournament, a: tournament.admin)}"]) }
    end
  end
end
