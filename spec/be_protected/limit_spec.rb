require 'spec_helper'
require 'shared_examples/responses'

describe BeProtected::Limit do
  let(:header) { {'Content-Type' => 'application/json'} }

  describe ".create" do
    let(:params) { {key: "USD_ID", volume: 1000, count: 145, max: 45} }
    let(:limit) do
      described_class.new do |builder|
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

end
