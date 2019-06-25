require 'spec_helper'
require 'shared_examples/responses'
require 'shared_examples/connection_failed'

describe BeProtected::Set do
  let(:header) { {'Content-Type' => 'application/json'} }
  let(:set) { described_class.new }

  before { BeProtected::Configuration.url = 'http://example.com' }

  describe ".create" do
    let(:params) { {name:"AllowedTypes", value: ["Payment", "Refund"]} }

    subject { set.create(params) }

    before do
      stub_request(:post, "http://example.com/sets")
        .with(body: params.to_json)
        .to_return(status: status, body: response, headers: header)
    end

    context "when response is successful" do
      let(:status)   { 201 }
      let(:response) { {uuid: '12ab', account_uuid: '34bc', name: "AllowedTypes", value: ["Payment"]}.to_json }

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
    subject { set.get('a1b2c3') }

    before do
      stub_request(:get, "http://example.com/sets/a1b2c3")
        .to_return(status: status, body: response, headers: header)
    end

    context "when response is successful" do
      let(:status)   { 200 }
      let(:response) { {uuid: 'a1b2c3', account_uuid: '34bc', name: "AllowedTypes", value: ["Payment"]}.to_json }

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
    subject { set.get }

    before do
      stub_request(:get, "http://example.com/sets")
        .to_return(status: status, body: response, headers: header)
    end

    context "when response is successful" do
      let(:status)   { 200 }
      let(:response) do
        {
          sets:
            [
              {uuid: "100cebebc", account_uuid: "c9510127", name: "AllowedTypes", value: ["Payment"]},
              {uuid: "200cebebc", account_uuid: "a1000127", name: "AllowedCountries", value: ["UK"]}
            ]
        }.to_json
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

    subject { set.update("a1b2c3", params) }

    before do
      stub_request(:post, "http://example.com/sets/a1b2c3")
        .with(body: params.to_json)
        .to_return(status: status, body: response, headers: header)
    end

    context "when response is successful" do
      let(:status)   { 200 }
      let(:response) { {uuid: 'a1b2c3', account_uuid: '34bc', name: "AllowedTypes", value: ["Payment", "Refund"]}.to_json }

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
    subject { set.delete("a1b2c3") }

    before do
      stub_request(:delete, "http://example.com/sets/a1b2c3")
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
