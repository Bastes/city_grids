require 'spec_helper'

describe CitiesController do
  describe "GET 'index'" do
    let!(:cities) { create_list(:city, 3).sort_by &:name }
    before { get 'index' }

    it { expect(response).to be_success }
    it { expect(assigns[:cities]).to eq cities }
  end

  describe "GET 'show'" do
    let!(:cities) { create_list :city, 3 }
    let(:city) { cities.sample }
    let!(:incoming_tournaments) { [3, 4, 0].map { |n| create :tournament, begins_at: n.days.from_now, city: city }.sort_by(&:begins_at) }
    before { create :tournament, :awaiting_activation, city: city }
    before { create :tournament, begins_at: 1.day.ago, city: city }
    before { create :tournament, begins_at: 1.day.from_now, city: (cities - [city]).sample }

    before { get 'show', id: city.id }

    it { expect(response).to be_success }
    it { expect(assigns[:city]).to eq city }
  end

  describe "GET 'new'" do
    before { get 'new' }

    it { expect(response).to be_success }
    it { expect(assigns[:city]).to be_a_new City }
  end

  describe "POST 'create'" do
    subject(:the_query) { -> { post 'create', city: city } }

    context 'with valid data' do
      let(:city) { attributes_for :city }

      it { should change(City, :count).by 1 }

      context 'after the query' do
        before { the_query.call }

        it { expect(response).to redirect_to assigns[:city] }
        it { expect(flash[:notice]).not_to be_nil }

        describe '@city' do
          subject { assigns[:city] }

          it { should be_a City }
          it { should_not be_a_new_record }
          its(:name) { should == city[:name] }
        end
      end
    end

    context 'with invalid data' do
      let!(:other_city) { create :city }
      let(:city) { attributes_for :city, name: other_city.name }

      it { should_not change(City, :count) }

      context 'after the query' do
        before { the_query.call }

        it { expect(response).to render_template :new }
        it { expect(flash[:notice]).to be_nil }

        describe '@city' do
          subject { assigns[:city] }

          it { should be_a_new City }
          its(:name) { should == city[:name] }
        end
      end
    end
  end
end
