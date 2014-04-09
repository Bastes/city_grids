require 'spec_helper'

describe CitiesController do
  describe "GET 'index'" do
    let!(:cities) { create_list(:city, 3).sort_by &:name }
    before { get 'index' }

    it { expect(response).to be_success }
    it { expect(assigns[:cities]).to eq cities }
  end
end
