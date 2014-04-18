require 'spec_helper'
require 'shared_examples/responses'

describe BeProtected::Limit do
  let(:header) { {'Content-Type' => 'application/json'} }
  let(:credentials) { {auth_login: 'account_uuid', auth_password: 'account_login'} }

  describe ".create" do
    let(:params) { {key: "USD_ID", volume: 1000, count: 145, max: 45} }
    let(:limit) do
      described_class.new(credentials) do |builder|
        builder.adapter :test do |stub|
          stub.post('/limits', params.to_json)  { |env| [status, header, response] }
        end
      end
    end

    subject { limit.create(params) }

    context "when response is successful" do
      let(:status)   { 201 }
      let(:response) { params.update(uuid: "LIMUUID").to_json }

      its(:status) { should == 201 }
      its(:uuid)   { should == params[:uuid] }
      its(:key)    { should == params[:key] }
      its(:max)    { should == params[:max] }
      its(:count)  { should == params[:count] }
      its(:volume) { should == params[:volume] }
      it_behaves_like "successful response"
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
  end

  describe ".update" do
    let(:params) { {key: "EUR_ID", volume: 2000, count: 245, max: 55} }
    let(:limit) do
      described_class.new(credentials) do |builder|
        builder.adapter :test do |stub|
          stub.post('/limits/uuid5', params.to_json)  { |env| [status, header, response] }
        end
      end
    end

    subject { limit.update("uuid5", params) }

    context "when response is successful" do
      let(:status)   { 200 }
      let(:response) { params.update(uuid: "uuid5").to_json }

      its(:status) { should == 200 }
      its(:uuid)   { should == params[:uuid] }
      its(:key)    { should == params[:key] }
      its(:max)    { should == params[:max] }
      its(:count)  { should == params[:count] }
      its(:volume) { should == params[:volume] }
      it_behaves_like "successful response"
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
  end

  describe ".get" do
    let(:params) { {key: "EUR_ID", volume: 2000, count: 245, max: 55} }
    let(:limit) do
      described_class.new(credentials) do |builder|
        builder.adapter :test do |stub|
          stub.get('/limits/uuid5')  { |env| [status, header, response] }
        end
      end
    end

    subject { limit.get("uuid5") }

    context "when response is successful" do
      let(:status)   { 200 }
      let(:response) { params.update(uuid: "uuid5").to_json }

      its(:status) { should == 200 }
      its(:uuid)   { should == params[:uuid] }
      its(:key)    { should == params[:key] }
      its(:max)    { should == params[:max] }
      its(:count)  { should == params[:count] }
      its(:volume) { should == params[:volume] }
      it_behaves_like "successful response"
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
  end

  describe ".decrease" do
    let(:params) { {created_at: "2014-04-17 10:47:40", value: 55} }
    let(:limit) do
      described_class.new(credentials) do |builder|
        builder.adapter :test do |stub|
          stub.post('/limits/uuid5/decrease', params.to_json)  { |env| [status, header, response] }
        end
      end
    end

    subject { limit.decrease("uuid5", params) }

    context "when response is successful" do
      let(:message)  { 'Successfully decreased.' }
      let(:status)   { 200 }
      let(:response) { {message: message}.to_json }

      its(:status)  { should == 200 }
      its(:message) { should == message}
      it_behaves_like "successful response"
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
  end

end
