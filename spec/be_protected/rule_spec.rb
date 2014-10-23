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
        alias: alias_name,
        active: true
      }
    end

    let(:rule) do
      described_class.new do |builder|
        builder.adapter :test do |stub|
          stub.post('/rules', params.to_json)  { |env| [status, header, response] }
        end
      end
    end

    subject { rule.create(params) }

    context "when response is successful" do
      let(:status)   { 201 }
      let(:response) do
        {
          uuid: "97cebebc",
          account_uuid: "c9510127",
          action: "review",
          condition: "Unique CardHolder count more than 5 in 36 hours",
          alias: "rule_1",
          active: true
        }
      end

      its(:status)   { should == 201 }
      its(:uuid)     { should == "97cebebc" }
      its(:account_uuid) { should == "c9510127" }
      its(:condition)    { should == "Unique CardHolder count more than 5 in 36 hours" }
      its(:alias)  { should == "rule_1" }
      its(:active) { should == true }
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
          alias: "rule_2",
          active: true
        }
      end

      its(:status)   { should == 200 }
      its(:uuid)     { should == "100cebebc" }
      its(:account_uuid) { should == "c9510127" }
      its(:condition)    { should == "Unique CardHolder count more than 5 in 36 hours" }
      its(:alias)  { should == "rule_2" }
      its(:active) { should == true }
      it_behaves_like "successful response"
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
    it_behaves_like "connection failed"
  end

  describe "get all rules" do
    let(:rule) do
      described_class.new do |builder|
        builder.adapter :test do |stub|
          stub.get('/rules')  { |env| [status, header, response] }
        end
      end
    end

    subject { rule.get }

    context "when response is successful" do
      let(:status)   { 200 }
      let(:response) do
        [{uuid: "100cebebc", account_uuid: "c9510127", action: "review",
           condition: "Unique CardHolder count more than 5 in 36 hours",
           alias: "rule_2", active: true},
         {uuid: "200cebebc", account_uuid: "a1000127", action: "reject",
           condition: "Unique CardHolder count more than 15 in 6 hours",
           alias: "rule_25", active: false}
        ]
      end

      its(:status)   { should == 200 }

      it "returns Response::Rule list" do
        expect(subject[0].uuid).to eq("100cebebc")
        expect(subject[0].action).to eq("review")
        expect(subject[0].alias).to eq("rule_2")
        expect(subject[1].account_uuid).to eq("a1000127")
        expect(subject[1].condition).to eq("Unique CardHolder count more than 15 in 6 hours")
        expect(subject[1].active).to eq(false)
      end
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
          alias: "rule_2",
          active: false
        }
      end

      its(:status)   { should == 200 }
      its(:uuid)     { should == "100cebebc" }
      its(:account_uuid) { should == "c9510127" }
      its(:condition)    { should == "Unique CardHolder count more than 5 in 36 hours" }
      its(:action)   { should == "reject" }
      its(:alias)    { should == "rule_2" }
      its(:active) { should == false }
      it_behaves_like "successful response"
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
    it_behaves_like "connection failed"
  end

  describe ".delete" do
    let(:rule) do
      described_class.new do |builder|
        builder.adapter :test do |stub|
          stub.delete('/rules/100cebebc') { |env| [status, header, response] }
        end
      end
    end

    subject { rule.delete("100cebebc") }

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

  describe ".add_data" do
    let(:params) { {
        ip: "211.10.9.8", email: "john@example.com", amount: 100, currency: "USD",
        card_number: "4200000000000000", card_holder: "Jane Doe", status: "failed",
        type: "Payment", created_at: "2014-09-09 06:21:24"
      } }

    let(:rule) do
      described_class.new do |builder|
        builder.adapter :test do |stub|
          stub.post('/rules/data', params.to_json)  { |env| [status, header, response] }
        end
      end
    end

    subject { rule.add_data(params) }

    context "when response is successful" do
      let(:status)   { 200 }
      let(:response) { {message: "Data was added."}.to_json }

      its(:status)   { should == 200 }
      its(:message)  { should == "Data was added." }
      it_behaves_like "successful response"
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
    it_behaves_like "connection failed"
  end

end
