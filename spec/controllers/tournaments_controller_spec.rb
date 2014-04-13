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
end
