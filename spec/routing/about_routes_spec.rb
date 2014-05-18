require 'spec_helper'

describe 'about routes' do
  it { expect(get: '/about').to route_to 'about#index' }
end
