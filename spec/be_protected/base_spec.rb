require 'spec_helper'

describe BeProtected::Base do
  let(:auth_login) { 'login' }
  let(:auth_password) { 'password' }
  let(:connection_opts) { {ssl: {}} }
  let(:connection_build) { Proc.new{} }
  let(:opts) { { auth_login: auth_login, auth_password: auth_password,
      connection_opts: connection_opts } }

  describe "initialize" do
    subject { described_class.new(opts, &connection_build) }

    it "assigns auth_login and auth_password" do
      expect(subject.auth_login).to eq(auth_login)
      expect(subject.auth_password).to eq(auth_password)
    end

    it "assigns options" do
      expect(subject.options).to eq({connection_opts: connection_opts, connection_build: connection_build})
    end
  end

  describe "#connection" do
    let(:url)   { 'http://beprotected.com:8080' }
    let(:proxy) { 'http://192.168.66.1:1234/' }

    before do
      BeProtected::Configuration.setup do |config|
        config.url   = url
        config.proxy = proxy
      end
    end

    subject do
      described_class.new(opts) do |builder|
        builder.adapter :test do |stub|
          stub.get('/headers') { |env| [200, {}, env[:request_headers]] }
        end
      end
    end

    it "assigns url from configuration" do
      expect(subject.connection.host).to eq('beprotected.com')
      expect(subject.connection.port).to eq(8080)
      expect(subject.connection.scheme).to eq('http')
    end

    it "assigns proxy from configuration" do
      require 'uri'
      expect(subject.connection.proxy[:uri].to_s).to eql(proxy)
    end

    it "configures Faraday connection" do
      builder  = double('builder')
      adapter  = double('adapter')
      connection = double('connection')

      allow(connection).to receive(:build).and_yield(builder)
      allow(Faraday::Connection).to receive(:new).and_return(connection)
      allow(Faraday).to receive(:default_adapter).and_return(adapter)
      expect(connection).to receive(:adapter).with(adapter)

      allow(connection).to receive(:basic_auth)
      allow(connection).to receive(:request).with(:json)
      allow(connection).to receive(:response).with(:json)
      expect(builder).to receive(:adapter).with(:test)

      subject.connection
    end
  end

end
