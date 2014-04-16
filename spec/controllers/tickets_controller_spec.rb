require 'spec_helper'

describe TicketsController do
  describe "GET 'new'" do
    let(:tournament) { create :tournament }

    before { get 'new', tournament_id: tournament.id }

    it { expect(response).to be_success }
    it { expect(assigns[:ticket]).to be_a_new Ticket }
    it { expect(assigns[:ticket].tournament).to eq tournament }
  end

  describe "POST 'create'" do
    let(:tournament) { create :tournament }

    subject(:the_query) { -> { post 'create', tournament_id: tournament.id, ticket: ticket } }

    context 'with valid data' do
      let(:ticket) { attributes_for :ticket }

      before { expect(TicketMailer).to receive(:activation).with(an_instance_of(Ticket)).and_return(double().tap { |d| expect(d).to receive(:deliver) }) }

      it { should change { tournament.reload.tickets.count }.by 1 }

      context 'after the query' do
        before { the_query.call }

        it { expect(response).to redirect_to tournament }
        it { expect(flash[:notice]).not_to be_nil }

        describe '@ticket' do
          subject { assigns[:ticket] }

          it { should be_a Ticket }
          it { should_not be_a_new_record }

          its(:tournament) { should == tournament }
          its(:email)      { should == ticket[:email] }
          its(:nickname)   { should == ticket[:nickname] }
        end
      end
    end

    context 'with invalid data' do
      let!(:other_ticket) { create :ticket, tournament: tournament }
      let(:ticket)        { attributes_for :ticket, nickname: other_ticket.nickname }

      before { expect(TicketMailer).not_to receive(:activation) }

      it { should_not change { tournament.reload.tickets.count } }

      context 'after the query' do
        before { the_query.call }

        it { expect(response).to render_template :new }
        it { expect(flash[:notice]).to be_nil }

        describe '@ticket' do
          subject { assigns[:ticket] }

          it { should be_a_new Ticket }

          its(:tournament) { should == tournament }
          its(:email)      { should == ticket[:email] }
          its(:nickname)   { should == ticket[:nickname] }
        end
      end
    end
  end

  describe 'GET "activate"' do
    let(:ticket) { create :ticket, :pending }
    subject(:the_query) { -> { get 'activate', id: ticket.id, a: admin } }

    context 'with the right admin token' do
      let(:admin) { ticket.admin }

      it { should change { ticket.reload.status }.to 'present' }

      describe 'after the query' do
        before { the_query.call }

        it { expect(response).to redirect_to ticket.tournament }
        it { expect(flash[:notice]).not_to be_nil }
      end
    end

    context 'without the right admin token' do
      let(:admin) { ticket.admin + ' oups' }

      it { should raise_error ActionController::RoutingError }
      it { expect(-> { the_query.call rescue nil }).not_to change { ticket.reload.status } }
    end
  end
end
