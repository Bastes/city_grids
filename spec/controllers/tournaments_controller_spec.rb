require 'spec_helper'

describe TournamentsController do
  describe "GET 'show'" do
    let(:tournament) { create :tournament }

    before { get 'show', id: tournament.id }

    it { expect(response).to be_success }
    it { expect(assigns[:tournament]).to eq tournament }
    it { expect(assigns[:tournament]).to be_decorated }
  end

  describe "GET 'new'" do
    let(:city) { create :city }

    before { get 'new', city_id: city.id }

    it { expect(response).to be_success }
    it { expect(assigns[:tournament]).to be_a_new Tournament }
    it { expect(assigns[:tournament].city).to eq city }
  end

  describe "GET 'edit'" do
    let(:tournament) { create :tournament }

    before { get 'edit', id: tournament.id, a: admin }

    context 'with the right admin token' do
      let(:admin) { tournament.admin }

      it { expect(response).to be_success }
      it { expect(assigns[:tournament]).to eq tournament }
      it { expect(assigns[:tournament]).not_to be_decorated }
    end

    context 'with the wrong admin token' do
      let(:admin) { "not quite #{tournament.admin}" }

      it { expect(response).to redirect_to tournament }
    end
  end

  describe "POST 'create'" do
    let(:city) { create :city }
    let(:tournament_attributes) do
      %i(organizer_email organizer_nickname name address places abstract).
        inject({}) { |r, k| r.tap { r[k] = tournament.send(k) } }.
        merge begins_at_date: I18n.l(tournament.send(:begins_at), format: '%Y-%m-%d'),
              begins_at_time: I18n.l(tournament.send(:begins_at), format: '%H:%M'),
              ends_at_time:   I18n.l(tournament.send(:ends_at),   format: '%H:%M')
    end

    subject(:the_query) { -> { post 'create', city_id: city.id, tournament: tournament_attributes } }

    context 'with valid data' do
      let(:tournament) { build :tournament }

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

          %i(organizer_email organizer_nickname name address begins_at ends_at places abstract).each do |field|
            its(field) { should == tournament.send(field) }
          end
        end
      end
    end

    context 'with invalid data' do
      let(:tournament) { build :tournament, organizer_email: 'I might have botched that one' }

      before { expect(TournamentMailer).not_to receive(:activation) }

      it { should_not change { city.reload.tournaments.count } }

      context 'after the query' do
        before { the_query.call }

        it { expect(response).to render_template :new }
        it { expect(flash[:notice]).to be_nil }

        describe '@tournament' do
          subject { assigns[:tournament] }

          it { should be_a_new Tournament }

          %i(organizer_email organizer_nickname name address begins_at ends_at places abstract).each do |field|
            its(field) { should == tournament.send(field) }
          end
        end
      end
    end
  end

  describe "POST 'update'" do
    let!(:tournament) { create :tournament }
    let(:tournament_attributes) do
      %i(organizer_email organizer_nickname name address places abstract).
        inject({}) { |r, k| r.tap { r[k] = other_tournament.send(k) } }.
        merge begins_at_date: I18n.l(other_tournament.send(:begins_at), format: '%Y-%m-%d'),
              begins_at_time: I18n.l(other_tournament.send(:begins_at), format: '%H:%M'),
              ends_at_time:   I18n.l(other_tournament.send(:ends_at),   format: '%H:%M')
    end

    subject(:the_query) { -> { put 'update', id: tournament.id, tournament: tournament_attributes, a: admin } }

    context 'with a valid admin token' do
      let(:admin) { tournament.admin }

      context 'with valid data' do
        let(:other_tournament) { build :tournament }

        it { should_not change(Tournament, :count) }

        context 'after the query' do
          before { the_query.call }

          it { expect(response).to redirect_to tournament_path(tournament.reload, a: tournament.admin) }
          it { expect(flash[:notice]).not_to be_nil }

          describe '@tournament' do
            subject { assigns[:tournament] }

            it { should be_a Tournament }
            it { should_not be_a_new_record }
            its(:id) { should eq tournament.id }

            %i(organizer_email organizer_nickname name address begins_at ends_at places abstract).each do |field|
              its(field) { should == other_tournament.send(field) }
            end
          end
        end
      end

      context 'with invalid data' do
        let(:other_tournament) { build :tournament, organizer_email: 'Er, not really an email now is it?' }

        it { should_not change { tournament.reload.updated_at } }

        context 'after the query' do
          before { the_query.call }

          it { expect(response).to render_template :edit }
          it { expect(flash[:notice]).to be_nil }

          describe '@tournament' do
            subject { assigns[:tournament] }

            its(:id) { should eq tournament.id }

            %i(organizer_email organizer_nickname name address begins_at ends_at places abstract).each do |field|
              its(field) { should == other_tournament.send(field) }
            end
          end
        end
      end
    end

    context 'with an invalid admin token' do
      let(:admin) { "Something wrong with #{tournament.admin}" }
      let(:other_tournament) { build :tournament }

      it { should_not change(Tournament, :count) }
      it { should_not change { tournament.reload.updated_at } }

      context 'after the query' do
        before { the_query.call }

        it { expect(response).to redirect_to tournament }
        it { expect(flash[:notice]).to be_nil }
      end
    end
  end

  describe 'GET "activate"' do
    subject(:the_query) { -> { get 'activate', id: tournament.id, a: admin } }

    context 'the tournament was pending' do
      let(:tournament) { create :tournament, :awaiting_activation }

      context 'with the right admin token' do
        let(:admin) { tournament.admin }

        before { expect(TournamentMailer).to receive(:administration).with(an_instance_of(Tournament)).and_return(double().tap { |d| expect(d).to receive(:deliver) }) }

        it { should change { tournament.reload.activated }.to true }

        describe 'after the query' do
          before { the_query.call }

          it { expect(response).to redirect_to tournament }
          it { expect(flash[:notice]).not_to be_nil }
        end
      end

      context 'without the right admin token' do
        let(:admin) { tournament.admin + ' oups' }

        before { expect(TournamentMailer).not_to receive(:administration) }

        it { should raise_error ActionController::RoutingError }
        it { expect(-> { the_query.call rescue nil }).not_to change { tournament.reload.activated } }
      end
    end

    context 'the tournament was already activated' do
      let(:tournament) { create :tournament, :activated }

      context 'with the right admin token' do
        let(:admin) { tournament.admin }

        before { expect(TournamentMailer).not_to receive(:administration) }

        it { should_not change { tournament.reload.updated_at } }

        describe 'after the query' do
          before { the_query.call }

          it { expect(response).to redirect_to tournament }
          it { expect(flash[:notice]).to be_nil }
        end
      end

      context 'without the right admin token' do
        let(:admin) { tournament.admin + ' whoot!!' }

        before { expect(TournamentMailer).not_to receive(:administration) }

        it { should raise_error ActionController::RoutingError }
        it { expect(-> { the_query.call rescue nil }).not_to change { tournament.reload.activated } }
      end
    end
  end
end
