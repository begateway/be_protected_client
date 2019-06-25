require 'uri'
require 'spec_helper'
require 'shared_examples/responses'
require 'shared_examples/connection_failed'

describe BeProtected::Whitelist do
  let(:header) { {'Content-Type' => 'application/json'} }
  let(:credentials) { {auth_login: 'account_uuid', auth_password: 'account_token'} }
  let(:whitelist) { described_class.new }
  let(:value) { "value" }

  before { BeProtected::Configuration.url = 'http://example.com' }

  describe ".add" do
    let(:method) { :post }
    let(:params) { { value: value } }

    subject { whitelist.add(value) }

    before do
      stub_request(:post, "http://example.com/whitelist")
        .with(body: params.to_json)
        .to_return(status: status, body: response, headers: header)
    end

    context "when response is successful" do
      let(:status)   { 201 }
      let(:response) { params.update(persisted: true).to_json }

      its(:status) { should == 201 }
      its(:value)  { should == value }
      its(:persisted) { should be true }
      it_behaves_like "successful response"
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
    it_behaves_like "connection failed"
  end

  describe ".get" do
    let(:params) { { value: value, persisted: true } }

    subject { whitelist.get(value) }

    before do
      stub_request(:get, "http://example.com/whitelist/#{value}")
        .to_return(status: status, body: response, headers: header)
    end

    context "when response is successful" do
      let(:status)   { 200 }
      let(:response) { params.to_json }

      its(:status) { should == 200 }
      its(:value)  { should == value }
      its(:persisted) { should be true }
      it_behaves_like "successful response"
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
    it_behaves_like "connection failed"
  end

  describe ".delete" do
    subject { whitelist.delete(value) }

    before do
      stub_request(:delete, "http://example.com/whitelist/#{value}")
        .to_return(status: status, body: response, headers: header)
    end

    context "when response is successful" do
      let(:status)   { 204 }
      let(:response) { nil }

      its(:status) { should == 204 }
      it_behaves_like "successful response"
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
    it_behaves_like "connection failed"
  end

end
