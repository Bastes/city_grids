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
end
