require 'spec_helper'

describe TournamentsController do
  describe "GET 'new'" do
    let(:city) { create :city }

    before { get 'new', city_id: city.id }

    it { expect(response).to be_success }
    it { expect(assigns[:tournament]).to be_a_new Tournament }
    it { expect(assigns[:tournament].city).to eq city }
  end

  describe "POST 'create'" do
    let(:city) { create :city }

    subject(:the_query) { -> { post 'create', city_id: city.id, tournament: tournament } }

    context 'with valid data' do
      let(:tournament) { attributes_for :tournament }

      before { expect(TournamentMailer).to receive(:activation).with(an_instance_of(Tournament)).and_return(double().tap { |d| expect(d).to receive(:deliver) }) }

      it { should change { city.reload.tournaments.count }.by 1 }

      context 'after the query' do
        before { the_query.call }

        it { expect(response).to redirect_to city }
        it { expect(flash[:notice]).not_to be_nil }

        describe '@tournament' do
          subject { assigns[:tournament] }

          it { should be_a Tournament }
          it { should_not be_a_new_record }

          %i(organizer_email organizer_alias name address begins_at ends_at places abstract).each do |field|
            its(field) { should == tournament[field] }
          end
        end
      end
    end

    context 'with invalid data' do
      let(:tournament) { attributes_for :tournament, organizer_email: 'I might have botched that one' }

      before { expect(TournamentMailer).not_to receive(:activation) }

      it { should_not change { city.reload.tournaments.count } }

      context 'after the query' do
        before { the_query.call }

        it { expect(response).to render_template :new }
        it { expect(flash[:notice]).to be_nil }

        describe '@tournament' do
          subject { assigns[:tournament] }

          it { should be_a_new Tournament }

          %i(organizer_email organizer_alias name address begins_at ends_at places abstract).each do |field|
            its(field) { should == tournament[field] }
          end
        end
      end
    end
  end

  describe 'GET "activate"' do
    let(:tournament) { create :tournament, :awaiting_activation }
    subject(:the_query) { -> { get 'activate', id: tournament.id, a: admin } }

    context 'with the right admin token' do
      let(:admin) { tournament.admin }

      it { should change { tournament.reload.activated }.to true }

      describe 'after the query' do
        before { the_query.call }

        it { expect(response).to redirect_to tournament.city }
        it { expect(flash[:notice]).not_to be_nil }
      end
    end

    context 'without the right admin token' do
      let(:admin) { tournament.admin + ' oups' }

      it { should raise_error ActionController::RoutingError }
      it { expect(-> { the_query.call rescue nil }).not_to change { tournament.reload.activated } }
    end
  end
end
