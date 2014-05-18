require 'spec_helper'

describe AboutController do
  before { get :index }

  it { expect(response).to be_success }
end
