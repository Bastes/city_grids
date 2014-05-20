require 'spec_helper'

describe 'cities/new.html.slim' do
  let(:city) { build :city }
  before { assign :city, city }

  before { render }

  subject { rendered }

  it { should_not have_selector %Q(.translation_missing) }

  specify 'the city form' do
    within %Q(#city-new form[action="#{cities_path}"][method="post"]) do |form|
      form.should have_selector %Q(input[name="city[name]"][value="#{city.name}"][type="text"])
      form.should have_selector %Q(input[name="city[email]"][value="#{city.email}"][type="email"])
      form.should have_selector %Q(input[type="submit"])
    end
  end
end
