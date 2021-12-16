require 'spec_helper'

describe BeProtected::Configuration do
  let(:url)   { "http://beprotected.com:5689/" }
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

    it "sets open_timeout" do
      described_class.setup do |config|
        config.open_timeout = 5
      end

      expect(described_class.open_timeout).to eq(5)
    end

    it "sets read_timeout" do
      described_class.setup do |config|
        config.read_timeout = 10
      end

      expect(described_class.read_timeout).to eq(10)
    end

    it "sets ssl configuration" do
      described_class.setup do |config|
        config.ssl = {verify: false}
      end

      expect(described_class.ssl).to eq({verify: false})
    end

  end
end
