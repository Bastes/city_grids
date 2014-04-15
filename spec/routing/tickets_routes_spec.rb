require 'spec_helper'

describe 'tickets routes' do
  let(:tournament_id) { rand 1..1000 }
  it { expect(get: "/tournaments/#{tournament_id}/tickets/new").to route_to('tickets#new', tournament_id: tournament_id.to_s) }
  it { expect(post: "/tournaments/#{tournament_id}/tickets").to route_to('tickets#create', tournament_id: tournament_id.to_s) }
end
