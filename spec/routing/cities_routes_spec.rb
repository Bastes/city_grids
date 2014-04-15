require 'spec_helper'

describe 'cities routes' do
  it { expect(get: '/').to route_to 'cities#index' }
  it { expect(get: "/cities/new").to route_to('cities#new') }
  it { expect(post: "/cities").to route_to('cities#create') }

  let(:id) { rand 1..1000 }
  it { expect(get: "/cities/#{id}").to route_to('cities#show', id: id.to_s) }
end
