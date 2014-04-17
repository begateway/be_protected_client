require 'spec_helper'

describe BeProtected::Configuration do
  let(:url)   { "http://be_protected.com:5689/" }
  let(:proxy) { "http://127.0.0.1:3214/" }

  describe ".setup" do
    it "sets URL to system" do
      described_class.setup do |config|
        config.url = url
      end

      expect(described_class.url).to eq(url)
    end

    it "sets proxy" do
      described_class.setup do |config|
        config.proxy = proxy
      end

      expect(described_class.proxy).to eq(proxy)
    end
  end
end
