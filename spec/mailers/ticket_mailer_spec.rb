require "spec_helper"

describe TicketMailer do
  describe '#activation' do
    let(:ticket) { create :ticket }
    subject(:mail) { TicketMailer.activation ticket }

    its(:subject) { should match %r{#{Regexp.escape ticket.tournament.name}} }
    its(:subject) { should match %r{#{Regexp.escape I18n.l(ticket.tournament.begins_at.to_date, format: :long)}} }
    its(:to)      { should eq [ticket.email] }
    its(:from)    { should eq ['no-reply@netrunner-tournaments.fr'] }

    %w{plain html}.each do |part|
      describe "in #{part}" do
        subject { message_part mail, part }

        it { should match %r{#{Regexp.escape ticket.nickname}} }
        it { should match %r{#{Regexp.escape ticket.tournament.name}} }
        it { should match %r{#{Regexp.escape I18n.l(ticket.tournament.begins_at.to_date, format: :long)}} }
      end
    end

    describe 'in plain' do
      subject { message_part mail, 'plain' }

      it { should match %r(#{Regexp.escape activate_ticket_url(ticket, a: ticket.admin)}) }
      it { should match %r(#{Regexp.escape forfeit_ticket_url(ticket, a: ticket.admin)}) }
    end

    describe 'in html' do
      subject { message_part mail, 'html' }

      it { should have_selector %Q(a[href="#{activate_ticket_url(ticket, a: ticket.admin)}"]) }
      it { should have_selector %Q(a[href="#{forfeit_ticket_url(ticket, a: ticket.admin)}"]) }
    end
  end
end
