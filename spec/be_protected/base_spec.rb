require 'spec_helper'

describe BeProtected::Base do
  let(:auth_login) { 'login' }
  let(:auth_password) { 'password' }
  let(:connection_opts) { {ssl: {}} }
  let(:connection_build) { Proc.new{} }
  let(:opts) { { auth_login: auth_login, auth_password: auth_password,
      connection_opts: connection_opts, headers: headers } }
  let(:headers) { {'RequestID' => 'some-id'} }

  describe "initialize" do
    subject { described_class.new(opts, &connection_build) }

    it "assigns auth_login and auth_password" do
      expect(subject.auth_login).to eq(auth_login)
      expect(subject.auth_password).to eq(auth_password)
    end

    it "assigns options" do
      expect(subject.options).to eq({connection_opts: connection_opts, connection_build: connection_build})
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
      connection = double('connection')

      allow(connection).to receive(:build).and_yield(builder)
      allow(Faraday::Connection).to receive(:new).and_return(connection)

      allow(connection).to receive(:basic_auth).with(auth_login, auth_password)
      allow(connection).to receive(:request).with(:json)
      allow(connection).to receive(:use).with(BeProtected::Middleware::ParseJson)
      expect(builder).to receive(:adapter).with(:test)

      subject.connection
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
