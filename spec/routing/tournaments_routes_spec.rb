require 'spec_helper'

describe 'tournaments routes' do
  let(:city_id) { rand 1..1000 }
  let(:id) { rand 1..1000 }
  it { expect(get: "/cities/#{city_id}/tournaments/new").to route_to('tournaments#new', city_id: city_id.to_s) }
  it { expect(post: "/cities/#{city_id}/tournaments").to route_to('tournaments#create', city_id: city_id.to_s) }

  it { expect(get: "/tournaments/#{id}").to route_to('tournaments#show', id: id.to_s) }
  it { expect(get: "/tournaments/#{id}/activate").to route_to('tournaments#activate', id: id.to_s) }
end
