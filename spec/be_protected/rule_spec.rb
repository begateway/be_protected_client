require 'spec_helper'
require 'shared_examples/responses'
require 'shared_examples/connection_failed'

describe BeProtected::Rule do
  let(:header) { {'Content-Type' => 'application/json'} }

  describe ".create" do
    let(:action) { "review" }
    let(:condition) { "Unique CardHolder count more than 5 in 36 hours" }
    let(:alias_name) { "rule_1" }
    let(:params) do
      {
        action: action,
        condition: condition,
        alias: alias_name
      }
    end

    let(:rule) do
      described_class.new do |builder|
        builder.adapter :test do |stub|
          stub.post('/rules', params.to_json)  { |env| [status, header, response] }
        end
      end
    end

    subject { rule.create(action, condition, alias_name) }

    context "when response is successful" do
      let(:status)   { 201 }
      let(:response) do
        {
          uuid: "97cebebc",
          account_uuid: "c9510127",
          action: "review",
          condition: "Unique CardHolder count more than 5 in 36 hours",
          alias: "rule_1"
        }
      end

      its(:status)   { should == 201 }
      its(:uuid)     { should == "97cebebc" }
      its(:account_uuid) { should == "c9510127" }
      its(:condition)    { should == "Unique CardHolder count more than 5 in 36 hours" }
      its(:alias) { should == "rule_1" }
      it_behaves_like "successful response"
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
    it_behaves_like "connection failed"
  end

  describe ".get" do
    let(:rule) do
      described_class.new do |builder|
        builder.adapter :test do |stub|
          stub.get('/rules/100cebebc')  { |env| [status, header, response] }
        end
      end
    end

    subject { rule.get("100cebebc") }

    context "when response is successful" do
      let(:status)   { 200 }
      let(:response) do
        {
          uuid: "100cebebc",
          account_uuid: "c9510127",
          action: "review",
          condition: "Unique CardHolder count more than 5 in 36 hours",
          alias: "rule_2"
        }
      end

      its(:status)   { should == 200 }
      its(:uuid)     { should == "100cebebc" }
      its(:account_uuid) { should == "c9510127" }
      its(:condition)    { should == "Unique CardHolder count more than 5 in 36 hours" }
      its(:alias) { should == "rule_2" }
      it_behaves_like "successful response"
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
    it_behaves_like "connection failed"
  end

  describe ".update" do
    let(:params) { { action: "reject" } }
    let(:rule) do
      described_class.new do |builder|
        builder.adapter :test do |stub|
          stub.post('/rules/100cebebc', params.to_json)  { |env| [status, header, response] }
        end
      end
    end

    subject { rule.update("100cebebc", params) }

    context "when response is successful" do
      let(:status)   { 200 }
      let(:response) do
        {
          uuid: "100cebebc",
          account_uuid: "c9510127",
          action: "reject",
          condition: "Unique CardHolder count more than 5 in 36 hours",
          alias: "rule_2"
        }
      end


      its(:status)   { should == 200 }
      its(:uuid)     { should == "100cebebc" }
      its(:account_uuid) { should == "c9510127" }
      its(:condition)    { should == "Unique CardHolder count more than 5 in 36 hours" }
      its(:action)   { should == "reject" }
      its(:alias)    { should == "rule_2" }
      it_behaves_like "successful response"
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
    it_behaves_like "connection failed"
  end

end
