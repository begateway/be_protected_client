require 'spec_helper'

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

      its(:success?) { should be_true }
      its(:status)   { should == 201 }
      its(:uuid)     { should == "1B" }
      its(:name)     { should == "Jane" }
      its(:token)    { should == "tok3" }
      its(:failed?)  { should be_false }
    end

    context "when response is faled" do
      let(:status)   { 404 }
      let(:response) { '{"error":"Bad request"}' }

      its(:failed?)  { should be_true }
      its(:status)   { should == 404 }
      its(:error)    { should == "Bad request" }
      its(:success?) { should be_false }
    end

    context "when response is unknown" do
      let(:status)   { 415 }
      let(:response) { nil }

      its(:failed?)  { should be_true }
      its(:status)   { should == 415 }
      its(:error)    { should == "Unknown response. Status is 415." }
      its(:success?) { should be_false }
    end
  end

end
