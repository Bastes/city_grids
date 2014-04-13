require 'spec_helper'

describe 'tournaments routes' do
  let(:city_id) { rand 1..1000 }
  it { expect(get: "/cities/#{city_id}/tournaments/new").to route_to('tournaments#new', city_id: city_id.to_s) }
  it { expect(post: "/cities/#{city_id}/tournaments").to route_to('tournaments#create', city_id: city_id.to_s) }
end
