require 'spec_helper'
require 'shared_examples/responses'
require 'shared_examples/connection_failed'

describe BeProtected::Set do
  let(:header) { {'Content-Type' => 'application/json'} }

  describe ".create" do
    let(:params) { {name:"AllowedTypes", value: ["Payment", "Refund"]} }

    let(:set) do
      described_class.new do |builder|
        builder.adapter :test do |stub|
          stub.post('/sets', params.to_json)  { |env| [status, header, response] }
        end
      end
    end

    subject { set.create(params) }

    context "when response is successful" do
      let(:status)   { 201 }
      let(:response) { {uuid: '12ab', account_uuid: '34bc', name: "AllowedTypes", value: ["Payment"]} }

      its(:status) { should == 201 }
      its(:uuid)   { should == "12ab" }
      its(:name)   { should == "AllowedTypes" }
      its(:value)  { should == ["Payment"] }
      its(:account_uuid) { should == "34bc" }
      it_behaves_like "successful response"
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
    it_behaves_like "connection failed"
  end

  describe ".get" do
    let(:set) do
      described_class.new do |builder|
        builder.adapter :test do |stub|
          stub.get('/sets/a1b2c3')  { |env| [status, header, response] }
        end
      end
    end

    subject { set.get('a1b2c3') }

    context "when response is successful" do
      let(:status)   { 200 }
      let(:response) { {uuid: 'a1b2c3', account_uuid: '34bc', name: "AllowedTypes", value: ["Payment"]} }

      its(:status) { should == 200 }
      its(:uuid)   { should == "a1b2c3" }
      its(:name)   { should == "AllowedTypes" }
      its(:value)  { should == ["Payment"] }
      its(:account_uuid) { should == "34bc" }
      it_behaves_like "successful response"
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
    it_behaves_like "connection failed"
  end

  describe "get all sets" do
    let(:set) do
      described_class.new do |builder|
        builder.adapter :test do |stub|
          stub.get('/sets')  { |env| [status, header, response] }
        end
      end
    end

    subject { set.get }

    context "when response is successful" do
      let(:status)   { 200 }
      let(:response) do
        {
          sets:
            [
              {uuid: "100cebebc", account_uuid: "c9510127", name: "AllowedTypes", value: ["Payment"]},
              {uuid: "200cebebc", account_uuid: "a1000127", name: "AllowedCountries", value: ["UK"]}
            ]
        }
      end

      its(:status)   { should == 200 }

      it "returns Response::Set list" do
        expect(subject.first.uuid).to eq("100cebebc")
        expect(subject.first.name).to eq("AllowedTypes")
        expect(subject[0].value).to eq(["Payment"])
        expect(subject[1].account_uuid).to eq("a1000127")
        expect(subject[1].name).to eq("AllowedCountries")
        expect(subject[1].value).to eq(["UK"])
      end
      it_behaves_like "successful response"
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
    it_behaves_like "connection failed"
  end

  describe ".update" do
    let(:params) { { value: ["Payment", "Refund"] } }
    let(:set) do
      described_class.new do |builder|
        builder.adapter :test do |stub|
          stub.post('/sets/a1b2c3', params.to_json)  { |env| [status, header, response] }
        end
      end
    end

    subject { set.update("a1b2c3", params) }

    context "when response is successful" do
      let(:status)   { 200 }
      let(:response) { {uuid: 'a1b2c3', account_uuid: '34bc', name: "AllowedTypes", value: ["Payment", "Refund"]} }

      its(:status) { should == 200 }
      its(:uuid)   { should == "a1b2c3" }
      its(:name)   { should == "AllowedTypes" }
      its(:value)  { should == ["Payment", "Refund"] }
      its(:account_uuid) { should == "34bc" }

      it_behaves_like "successful response"
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
    it_behaves_like "connection failed"
  end

  describe ".delete" do
    let(:set) do
      described_class.new do |builder|
        builder.adapter :test do |stub|
          stub.delete('/sets/a1b2c3') { |env| [status, header, response] }
        end
      end
    end

    subject { set.delete("a1b2c3") }

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
