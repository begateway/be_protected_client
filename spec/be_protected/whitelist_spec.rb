require 'uri'
require 'spec_helper'
require 'shared_examples/responses'

describe BeProtected::Whitelist do
  let(:header) { {'Content-Type' => 'application/json'} }
  let(:credentials) { {auth_login: 'account_uuid', auth_password: 'account_token'} }
  let(:value)  { "any value" }

  describe ".add" do
    let(:params) { {value: value} }
    let(:whitelist) do
      described_class.new(credentials) do |builder|
        builder.adapter :test do |stub|
          stub.post('/whitelist', params.to_json)  { |env| [status, header, response] }
        end
      end
    end

    subject { whitelist.add(value) }

    context "when response is successful" do
      let(:status)   { 201 }
      let(:response) { params.update(persisted: true).to_json }

      its(:status) { should == 201 }
      its(:value)  { should == value }
      its(:persisted) { should be_true }
      it_behaves_like "successful response"
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
  end

  describe ".get" do
    let(:params) { {value: value, persisted: true} }
    let(:whitelist) do
      described_class.new(credentials) do |builder|
        builder.adapter :test do |stub|
          stub.get(URI.escape("/whitelist/#{value}")) { |env| [status, header, response] }
        end
      end
    end

    subject { whitelist.get(value) }

    context "when response is successful" do
      let(:status)   { 200 }
      let(:response) { params.to_json }

      its(:status) { should == 200 }
      its(:value)  { should == value }
      its(:persisted) { should be_true }
      it_behaves_like "successful response"
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
  end

  describe ".delete" do
    let(:whitelist) do
      described_class.new(credentials) do |builder|
        builder.adapter :test do |stub|
          stub.delete(URI.escape("/whitelist/#{value}")) { |env| [status, header, response] }
        end
      end
    end

    subject { whitelist.delete(value) }

    context "when response is successful" do
      let(:status)   { 204 }
      let(:response) { nil }

      its(:status) { should == 204 }
      it_behaves_like "successful response"
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
  end

end
