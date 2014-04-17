require 'spec_helper'

describe 'tickets routes' do
  let(:id)            { rand 1..1000 }
  let(:tournament_id) { rand 1..1000 }
  it { expect(get: "/tournaments/#{tournament_id}/tickets/new").to route_to('tickets#new', tournament_id: tournament_id.to_s) }
  it { expect(post: "/tournaments/#{tournament_id}/tickets").to route_to('tickets#create', tournament_id: tournament_id.to_s) }

  it { expect(get: "/tickets/#{id}/activate").to route_to('tickets#activate', id: id.to_s) }
  it { expect(get: "/tickets/#{id}/forfeit").to  route_to('tickets#forfeit',  id: id.to_s) }
end
