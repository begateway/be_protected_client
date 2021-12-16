require 'spec_helper'

describe BeProtected::Base do
  let(:auth_login) { 'login' }
  let(:auth_password) { 'password' }
  let(:connection_opts) { {ssl: {}} }
  let(:opts) { { auth_login: auth_login, auth_password: auth_password,
      connection_opts: connection_opts, headers: headers } }
  let(:headers) { {'RequestID' => 'some-id'} }

  describe "initialize" do
    subject { described_class.new(opts) }

    it "assigns auth_login and auth_password" do
      expect(subject.auth_login).to eq(auth_login)
      expect(subject.auth_password).to eq(auth_password)
    end

    it "assigns connection options" do
      expect(subject.connection_opts).to eq(connection_opts)
    end

    it "assigns passed headers" do
      expect(subject.passed_headers).to eq(headers)
    end
  end

  describe "#connection" do
    let(:url)   { 'http://beprotected.com:8080' }
    let(:proxy) { 'http://192.168.66.1:1234/' }
    let(:read_timeout) { 25 }
    let(:open_timeout) { 15 }

    before do
      BeProtected::Configuration.setup do |config|
        config.url   = url
        config.proxy = proxy
        config.read_timeout = read_timeout
        config.open_timeout = open_timeout
      end

      Faraday::Adapter::Test::Stubs.new do |stub|
        stub.get('/headers') { |env| [200, {}, env[:request_headers]] }
      end
    end

    subject { described_class.new(opts) }

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
      connection = subject.connection

      expect(connection).to be_instance_of Faraday::Connection
      expect(connection.builder.handlers).to eq [Faraday::Request::BasicAuthentication,
                                                 FaradayMiddleware::EncodeJson,
                                                 BeProtected::Middleware::ParseJson]
    end

    it "sets passed headers" do
      expect(subject.connection.headers).to include(headers)
    end

    it "sets read_timeout and open_timeout" do
      expect(subject.connection.options.timeout).to eq(read_timeout)
      expect(subject.connection.options.open_timeout).to eq(open_timeout)
    end
  end

end
