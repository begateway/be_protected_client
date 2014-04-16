require 'spec_helper'
require 'shared_examples/responses'

describe BeProtected::Account do
  let(:header) { {'Content-Type' => 'application/json'} }

  describe ".create" do
    let(:account) do
      described_class.new do |builder|
        builder.adapter :test do |stub|
          stub.post('/accounts')  { |env| [status, header, response] }
        end
      end
    end

    subject { account.create("Jane") }

    context "when response is successful" do
      let(:status)   { 201 }
      let(:response) { {uuid: "1B", token:"tok3", name:"Jane"}.to_json }

      its(:status)   { should == 201 }
      its(:uuid)     { should == "1B" }
      its(:name)     { should == "Jane" }
      its(:token)    { should == "tok3" }
      it_behaves_like "successful response"
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
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
      let(:response) { {uuid: "uuid2", token:"tok3", name:"Jane"}.to_json }

      its(:status)   { should == 200 }
      its(:uuid)     { should == "uuid2" }
      its(:name)     { should == "Jane" }
      its(:token)    { should == "tok3" }
      it_behaves_like "successful response"
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
  end

end
