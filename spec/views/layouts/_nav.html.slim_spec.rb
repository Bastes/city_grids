require 'spec_helper'

describe 'layouts/_nav.html.slim' do
  let(:city) { nil }

  before { allow(view).to receive(:current_city).and_return(city) }

  before { render }

  subject { rendered }

  it { should_not have_selector %Q(.translation_missing) }

  it { should have_selector %Q(nav.top-bar[data-topbar] ul.title-area li.name h1 a[href="#{root_path}"]) }

  context 'under a city' do
    let(:city) { create :city }

    it { should have_selector %Q(nav.top-bar[data-topbar] section.top-bar-section ul.left li.active a[href="#{city_path(city)}"]), text: city.name }
  end
end
