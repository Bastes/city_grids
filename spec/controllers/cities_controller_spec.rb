require 'spec_helper'

describe CitiesController do
  describe "GET 'index'" do
    let!(:cities) { create_list(:city, 3).sort_by &:name }
    before { create_list(:city, 2, :pending) }
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

    context 'standard case' do
      context 'with valid data' do
        let(:city) { attributes_for :city }

        before { expect(CityMailer).to receive(:activation).with(an_instance_of(City)).and_return(double().tap { |d| expect(d).to receive(:deliver) }) }

        it { should change(City, :count).by 1 }

        context 'after the query' do
          before { the_query.call }

          it { expect(response).to redirect_to root_path }
          it { expect(flash[:notice]).not_to be_nil }

          describe '@city' do
            subject { assigns[:city] }

            it { should be_a City }
            it { should_not be_a_new_record }
            its(:name) { should == city[:name] }
            its(:email) { should == city[:email] }
          end
        end
      end

      context 'with invalid data' do
        let(:city) { attributes_for :city, name: '' }

        before { expect(CityMailer).not_to receive(:activation) }

        it { should_not change(City, :count) }

        context 'after the query' do
          before { the_query.call }

          it { expect(response).to render_template :new }
          it { expect(flash[:notice]).to be_nil }

          describe '@city' do
            subject { assigns[:city] }

            it { should be_a_new City }
            its(:name)      { should == city[:name] }
            its(:email)     { should == city[:email] }
            its(:activated) { should be_false }
          end
        end
      end
    end

    context 'with a duplicate name on a pending city' do
      let!(:other_city) { create :city, :pending }

      context 'with a valid email' do
        let(:city) { attributes_for :city, name: other_city.name.upcase, email: "#{rand 1..100}-#{other_city.email}" }

        before { expect(CityMailer).to receive(:activation).with(an_instance_of(City)).and_return(double().tap { |d| expect(d).to receive(:deliver) }) }

        it { should_not change(City, :count) }
        it { should_not change { other_city.reload.name } }
        it { should_not change { other_city.reload.admin } }
        it { should_not change { other_city.reload.activated } }
        it { should change { other_city.reload.email }.to city[:email] }

        context 'after the query' do
          before { the_query.call }

          it { expect(response).to redirect_to root_path }
          it { expect(flash[:notice]).not_to be_nil }

          describe '@city' do
            subject { assigns[:city] }

            it { should eq other_city }
          end
        end
      end

      context 'with an invalid email' do
        let(:city) { attributes_for :city, name: other_city.name.upcase, email: '' }

        before { expect(CityMailer).not_to receive(:activation) }

        it { should_not change(City, :count) }
        it { should_not change { other_city.reload.name } }
        it { should_not change { other_city.reload.email } }
        it { should_not change { other_city.reload.admin } }
        it { should_not change { other_city.reload.activated } }

        context 'after the query' do
          before { the_query.call }

          it { expect(response).to render_template :new }
          it { expect(flash[:notice]).to be_nil }

          describe '@city' do
            subject { assigns[:city] }

            it { should be_a_new City }
            its(:name)      { should == city[:name] }
            its(:email)     { should == city[:email] }
          end
        end
      end
    end

    context 'with a duplicate name on an activated city' do
      let!(:other_city) { create :city, :activated }
      let(:city) { attributes_for :city, name: other_city.name.upcase }

      before { expect(CityMailer).not_to receive(:activation) }

      it { should_not change(City, :count) }
      it { should_not change { other_city.reload.name } }
      it { should_not change { other_city.reload.email } }
      it { should_not change { other_city.reload.admin } }
      it { should_not change { other_city.reload.activated } }

      context 'after the query' do
        before { the_query.call }

        it { expect(response).to redirect_to other_city }
        it { expect(flash[:notice]).to be_nil }
      end
    end
  end

  describe 'GET "activate"' do
    let(:city) { create :city, :pending }
    subject(:the_query) { -> { get 'activate', id: city.id, a: admin } }

    context 'with the right admin token' do
      let(:admin) { city.admin }

      it { should change { city.reload.activated }.to true }

      describe 'after the query' do
        before { the_query.call }

        it { expect(response).to redirect_to city }
        it { expect(flash[:notice]).not_to be_nil }
      end
    end

    context 'without the right admin token' do
      let(:admin) { city.admin + ' meh' }

      it { should raise_error ActionController::RoutingError }
      it { expect(-> { the_query.call rescue nil }).not_to change { city.reload.activated } }
    end
  end
end
