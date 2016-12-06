require 'spec_helper'
require 'shared_examples/responses'
require 'shared_examples/connection_failed'

describe BeProtected::Rule do
  let(:header) { {'Content-Type' => 'application/json'} }
  let(:created_at) { Time.now.to_s }

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
          created_at: created_at,
          active: true
        }
      end

      its(:status)   { should == 201 }
      its(:uuid)     { should == "97cebebc" }
      its(:account_uuid) { should == "c9510127" }
      its(:condition)    { should == "Unique CardHolder count more than 5 in 36 hours" }
      its(:alias)  { should == "rule_1" }
      its(:active) { should == true }
      its(:created_at) { should == created_at }
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
          created_at: created_at,
          active: true
        }
      end

      its(:status)   { should == 200 }
      its(:uuid)     { should == "100cebebc" }
      its(:account_uuid) { should == "c9510127" }
      its(:condition)    { should == "Unique CardHolder count more than 5 in 36 hours" }
      its(:alias)  { should == "rule_2" }
      its(:active) { should == true }
      its(:created_at) { should == created_at }
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
        { rules:
          [{uuid: "100cebebc", account_uuid: "c9510127", action: "review",
             condition: "Unique CardHolder count more than 5 in 36 hours",
             alias: "rule_2", active: true, created_at: created_at},
           {uuid: "200cebebc", account_uuid: "a1000127", action: "reject",
             condition: "Unique CardHolder count more than 15 in 6 hours",
             alias: "rule_25", active: false, created_at: created_at},
           {uuid: "200cebddc", account_uuid: "b1000213", action: "skip_3ds",
             condition: "Transaction amount less than 10 USD",
             alias: "rule_25", active: true, created_at: created_at}
          ]
        }
      end

      its(:status)   { should == 200 }

      it "returns Response::Rule list" do
        expect(subject.first.uuid).to eq("100cebebc")
        expect(subject[0].action).to eq("review")
        expect(subject[0].alias).to eq("rule_2")
        expect(subject[0].created_at).to eq(created_at)
        expect(subject[1].account_uuid).to eq("a1000127")
        expect(subject[1].condition).to eq("Unique CardHolder count more than 15 in 6 hours")
        expect(subject[1].active).to eq(false)
        expect(subject[2].action).to eq("skip_3ds")
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
          created_at: created_at,
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
      its(:created_at) { should == created_at }

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
        ip_address: "211.10.9.8", email: "john@example.com", amount: 100, currency: "USD",
        pan: "4200000000000000", pan_name: "Jane Doe", status: "failed",
        type: "Payment", created_at: "2014-09-09 06:21:24", device_id: "uno",
        billing_address: "111 1st Street", bin: "420000", ip_country: "US",
        bin_country: "CA", customer_name: "Smith", phone_number: nil,
        billing_address_country: "CA"
      } }
    let(:converted_params) {
      converted = params.clone
      converted[:phone_number] = ''
      converted
    }

    let(:rule) do
      described_class.new do |builder|
        builder.adapter :test do |stub|
          stub.post('/rules/data', converted_params.to_json)  { |env| [status, header, response] }
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
