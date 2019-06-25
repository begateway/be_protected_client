require 'spec_helper'
require 'shared_examples/responses'
require 'shared_examples/connection_failed'

describe BeProtected::Account do
  let(:header) { {'Content-Type' => 'application/json'} }
  let(:account) { described_class.new }

  before { BeProtected::Configuration.url = 'http://example.com' }

  describe ".create" do
    let(:params) { {name: "Jane", parent_uuid: "123abc"} }

    subject { described_class.new.create(params) }

    before do
      stub_request(:post, "http://example.com/accounts")
        .with(body: params.to_json)
        .to_return(status: status, body: response, headers: header)
    end

    context "when response is successful" do
      let(:status)   { 201 }
      let(:response) { {uuid: "1B", token:"tok3", name:"Jane", parent_uuid: "123abc"}.to_json }

      its(:status)   { should == 201 }
      its(:uuid)     { should == "1B" }
      its(:name)     { should == "Jane" }
      its(:token)    { should == "tok3" }
      its(:parent_uuid) { should == "123abc" }
      it_behaves_like "successful response"
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
    it_behaves_like "connection failed"
  end

  describe ".get" do
    subject { account.get("uuid2") }

    before do
      stub_request(:get, "http://example.com/accounts/uuid2")
        .to_return(status: status, body: response, headers: header)
    end

    context "when response is successful" do
      let(:status)   { 200 }
      let(:response) { {uuid: "uuid2", token:"tok3", name:"Jane", parent_uuid: "123abc"}.to_json }

      its(:status)   { should == 200 }
      its(:uuid)     { should == "uuid2" }
      its(:name)     { should == "Jane" }
      its(:token)    { should == "tok3" }
      its(:parent_uuid) { should == "123abc" }
      it_behaves_like "successful response"
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
    it_behaves_like "connection failed"
  end

  describe ".update" do
    let(:params) { {name: "John", parent_uuid: "567abc"} }

    subject { account.update("uuid2", params) }

    before do
      stub_request(:post, "http://example.com/accounts/uuid2")
        .with(body: params.to_json)
        .to_return(status: status, body: response, headers: header)
    end

    context "when response is successful" do
      let(:status)   { 200 }
      let(:response) { {uuid: "uuid2", token:"tok3", name:"John", parent_uuid: "567abc"}.to_json }

      its(:status)   { should == 200 }
      its(:uuid)     { should == "uuid2" }
      its(:name)     { should == "John" }
      its(:token)    { should == "tok3" }
      its(:parent_uuid) { should == "567abc" }
      it_behaves_like "successful response"
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
    it_behaves_like "connection failed"
  end

end
