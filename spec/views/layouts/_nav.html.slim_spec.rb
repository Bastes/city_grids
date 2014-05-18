require 'spec_helper'

describe 'layouts/_nav.html.slim' do
  let(:city) { nil }
  let(:controller_name) { 'whatever' }

  before { allow(view).to receive(:controller).and_return(double().tap { |d| allow(d).to receive(:controller_name).and_return(controller_name) }) }
  before { allow(view).to receive(:current_city).and_return(city) }

  before { render }

  subject { rendered }

  it { should_not have_selector %Q(.translation_missing) }

  it { should have_selector %Q(nav.top-bar[data-topbar] ul.title-area li.name h1 a[href="#{root_path}"]) }
  it { should have_selector %Q(nav.top-bar[data-topbar] ul.title-area li.toggle-topbar.menu-icon a[href="#"] span) }

  it { should have_selector %Q(nav.top-bar[data-topbar] section.top-bar-section .right li:not(.active) a[href="#{about_path}"]) }

  context 'under "about"' do
    let(:controller_name) { 'about' }

    it { should have_selector %Q(nav.top-bar[data-topbar] section.top-bar-section .right li.active a[href="#{about_path}"]) }
  end

  context 'under a city' do
    let(:city) { create :city }

    it { should have_selector %Q(nav.top-bar[data-topbar] section.top-bar-section ul.left li.active a[href="#{city_path(city)}"]), text: city.name }
  end
end
