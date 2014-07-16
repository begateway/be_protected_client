require 'uri'
require 'spec_helper'
require 'shared_examples/responses'

describe BeProtected::Blacklist do
  let(:header) { {'Content-Type' => 'application/json'} }
  let(:credentials) { {auth_login: 'account_uuid', auth_password: 'account_token'} }
  let(:value)  { "any value" }

  describe ".add" do
    let(:params) { {value: value} }
    let(:blacklist) do
      described_class.new(credentials) do |builder|
        builder.adapter :test do |stub|
          stub.post('/blacklist', params.to_json)  { |env| [status, header, response] }
        end
      end
    end

    subject { blacklist.add(value) }

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
    let(:blacklist) do
      described_class.new(credentials) do |builder|
        builder.adapter :test do |stub|
          stub.get(URI.escape("/blacklist/#{value}")) { |env| [status, header, response] }
        end
      end
    end

    subject { blacklist.get(value) }

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
    let(:blacklist) do
      described_class.new(credentials) do |builder|
        builder.adapter :test do |stub|
          stub.delete(URI.escape("/blacklist/#{value}")) { |env| [status, header, response] }
        end
      end
    end

    subject { blacklist.delete(value) }

    context "when response is successful" do
      let(:status)   { 204 }
      let(:response) { nil }

      its(:status) { should == 204 }
      it_behaves_like "successful response"
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
  end

  describe ".included?" do
    let(:params) { {value: value, persisted: true} }
    let(:blacklist) do
      described_class.new(credentials) do |builder|
        builder.adapter :test do |stub|
          stub.get(URI.escape("/blacklist/#{value}")) { |env| [status, header, response] }
        end
      end
    end

    subject { blacklist.included?(value) }

    context "when value is included in blacklist" do
      let(:status)   { 200 }
      let(:response) { params.to_json }

      it { should be_true }
    end

    context "when value is not included in blacklist" do
      let(:params)   { { error: 'The resource could not be found.' } }
      let(:status)   { 404 }
      let(:response) { params.to_json }

      it { should be_false }
    end

    context "when response is unknown" do
      let(:status)   { 503 }
      let(:response) { 'unknown response' }

      it { should be_nil }
    end
  end

end
