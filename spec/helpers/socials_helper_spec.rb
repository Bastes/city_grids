require 'spec_helper'

describe SocialsHelper do
  helper SocialsHelper

  let(:current_url) { "http://www.myurl.com" }

  before { allow(self).to receive(:request) { double(url: current_url) } }

  describe "#metatags_share" do
    subject { metatags_share }

    context "no argument given" do
      it { should be_nil }
    end

    context "with a hash" do
      before { metatags_share(content_hash) }

      context "with only a title in a tag" do
        let(:content_hash) { { title: "<strong>Title&nbsp;title</strong>" } }

        it { should have_selector('meta[property="og:title"][content="Title title"]', visible: false) }
      end

      context "with html safe values" do
        let(:content_hash) { { one: "One", two: "Two", three: "Three" } }

        its(:html_safe?) { should == true }
      end

      context "with a blank value" do
        let(:content_hash) { { image: nil } }

        it { should_not have_selector('meta[property="og:image"]', visible: false) }
      end


      context "without url tag" do
        let(:content_hash) { { title: "Title" } }

        it { should have_selector(%Q(meta[property="og:url"][content="#{current_url}"]), visible: false) }
      end

      context "with a url tag" do
        let(:content_hash) { { url: "http://www.differenturl.com" } }

        it { should have_selector(%Q(meta[property="og:url"][content="#{content_hash[:url]}"]), visible: false) }
      end
    end
  end
end
