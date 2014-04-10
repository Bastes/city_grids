require 'spec_helper'

describe 'cities routes' do
  it { expect(get: '/').to route_to 'cities#index' }

  let(:id) { rand 1..1000 }
  it { expect(get: "/cities/#{id}").to route_to('cities#show', id: id.to_s) }
end
