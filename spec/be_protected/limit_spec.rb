require 'spec_helper'
require 'shared_examples/responses'
require 'shared_examples/connection_failed'

describe BeProtected::Limit do
  let(:header) { {'Content-Type' => 'application/json'} }
  let(:credentials) { {auth_login: 'account_uuid', auth_password: 'account_token'} }
  let(:limit) { described_class.new }

  before { BeProtected::Configuration.url = 'http://example.com' }

  describe ".create" do
    let(:params) { {key: "USD_ID", volume: 1000, count: 145, max: 45, uuid: "LIMUUID"} }

    subject { limit.create(params) }

    before do
      stub_request(:post, "http://example.com/limits")
        .with(body: params.to_json)
        .to_return(status: status, body: response, headers: header)
    end

    context "when response is successful" do
      let(:status)   { 201 }
      let(:response) { params.to_json }

      its(:status) { should == 201 }
      its(:uuid)   { should == params[:uuid] }
      its(:key)    { should == params[:key] }
      its(:max)    { should == params[:max] }
      its(:count)  { should == params[:count] }
      its(:volume) { should == params[:volume] }
      it_behaves_like "successful response"
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
    it_behaves_like "connection failed"
  end

  describe ".update" do
    let(:params) { {key: "EUR_ID", volume: 2000, count: 245, max: 55, uuid: "uuid5"} }

    subject { limit.update("uuid5", params) }

    before do
      stub_request(:post, "http://example.com/limits/uuid5")
        .with(body: params.to_json)
        .to_return(status: status, body: response, headers: header)
    end

    context "when response is successful" do
      let(:status)   { 200 }
      let(:response) { params.to_json }

      its(:status) { should == 200 }
      its(:uuid)   { should == params[:uuid] }
      its(:key)    { should == params[:key] }
      its(:max)    { should == params[:max] }
      its(:count)  { should == params[:count] }
      its(:volume) { should == params[:volume] }
      it_behaves_like "successful response"
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
    it_behaves_like "connection failed"
  end

  describe ".get" do
    let(:params) { {key: "EUR_ID", volume: 2000, count: 245, max: 55} }

    subject { limit.get("uuid5") }

    before do
      stub_request(:get, "http://example.com/limits/uuid5")
        .to_return(status: status, body: response, headers: header)
    end

    context "when response is successful" do
      let(:status)   { 200 }
      let(:response) { params.update(uuid: "uuid5").to_json }

      its(:status) { should == 200 }
      its(:uuid)   { should == params[:uuid] }
      its(:key)    { should == params[:key] }
      its(:max)    { should == params[:max] }
      its(:count)  { should == params[:count] }
      its(:volume) { should == params[:volume] }
      it_behaves_like "successful response"
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
    it_behaves_like "connection failed"
  end

  describe ".decrease" do
    let(:params) { {created_at: "2014-04-17 10:47:40", value: 55} }

    before do
      stub_request(:post, "http://example.com/limits/uuid5/decrease")
        .with(body: params.to_json)
        .to_return(status: status, body: response, headers: header)
    end

    subject { limit.decrease("uuid5", params) }

    context "when response is successful" do
      let(:message)  { 'Successfully decreased.' }
      let(:status)   { 200 }
      let(:response) { {message: message}.to_json }

      its(:status)  { should == 200 }
      its(:message) { should == message}
      it_behaves_like "successful response"
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
    it_behaves_like "connection failed"
  end

end
