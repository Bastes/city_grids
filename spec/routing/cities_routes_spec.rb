require 'spec_helper'

describe 'cities routes' do
  it { expect(get: '/').to route_to 'cities#index' }
end
