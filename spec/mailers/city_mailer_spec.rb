require "spec_helper"

describe CityMailer do
  describe '#activation' do
    let(:city) { create :city }
    subject(:mail) { CityMailer.activation city }

    its(:subject) { should match %r{#{Regexp.escape city.name}} }
    its(:to)      { should eq [city.email] }
    its(:from)    { should eq ['no-reply@netrunner-tournaments.fr'] }

    %w{plain html}.each do |part|
      describe "in #{part}" do
        subject { message_part mail, part }

        it { should match %r{#{Regexp.escape city.name}} }
        it { should_not have_selector(%Q(.translation_missing)) }
      end
    end

    describe 'in plain' do
      subject { message_part mail, 'plain' }

      it { should match %r(#{Regexp.escape activate_city_url(city, a: city.admin)}) }
    end

    describe 'in html' do
      subject { message_part mail, 'html' }

      it { should have_selector %Q(a[href="#{activate_city_url(city, a: city.admin)}"]) }
    end
  end
end
