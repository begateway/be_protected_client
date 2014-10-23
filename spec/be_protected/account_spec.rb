require 'spec_helper'
require 'shared_examples/responses'
require 'shared_examples/connection_failed'

describe BeProtected::Account do
  let(:header) { {'Content-Type' => 'application/json'} }

  describe ".create" do
    let(:params) { {name: "Jane", parent_uid: "123abc"} }
    let(:account) do
      described_class.new do |builder|
        builder.adapter :test do |stub|
          stub.post('/accounts', params.to_json)  { |env| [status, header, response] }
        end
      end
    end

    subject { account.create(params) }

    context "when response is successful" do
      let(:status)   { 201 }
      let(:response) { {uuid: "1B", token:"tok3", name:"Jane", parent_uid: "123abc"}.to_json }

      its(:status)   { should == 201 }
      its(:uuid)     { should == "1B" }
      its(:name)     { should == "Jane" }
      its(:token)    { should == "tok3" }
      its(:parent_uid) { should == "123abc" }
      it_behaves_like "successful response"
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
    it_behaves_like "connection failed"
  end

  describe ".get" do
    let(:account) do
      described_class.new do |builder|
        builder.adapter :test do |stub|
          stub.get('/accounts/uuid2')  { |env| [status, header, response] }
        end
      end
    end

    subject { account.get("uuid2") }

    context "when response is successful" do
      let(:status)   { 200 }
      let(:response) { {uuid: "uuid2", token:"tok3", name:"Jane", parent_uid: "123abc"}.to_json }

      its(:status)   { should == 200 }
      its(:uuid)     { should == "uuid2" }
      its(:name)     { should == "Jane" }
      its(:token)    { should == "tok3" }
      its(:parent_uid) { should == "123abc" }
      it_behaves_like "successful response"
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
    it_behaves_like "connection failed"
  end

  describe ".update" do
    let(:params) { {name: "John", parent_uid: "567abc"} }
    let(:account) do
      described_class.new do |builder|
        builder.adapter :test do |stub|
          stub.post('/accounts/uuid2', params.to_json)  { |env| [status, header, response] }
        end
      end
    end

    subject { account.update("uuid2", params) }

    context "when response is successful" do
      let(:status)   { 200 }
      let(:response) { {uuid: "uuid2", token:"tok3", name:"John", parent_uid: "567abc"}.to_json }

      its(:status)   { should == 200 }
      its(:uuid)     { should == "uuid2" }
      its(:name)     { should == "John" }
      its(:token)    { should == "tok3" }
      its(:parent_uid) { should == "567abc" }
      it_behaves_like "successful response"
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
    it_behaves_like "connection failed"
  end

end
