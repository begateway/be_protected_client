require 'spec_helper'
require 'shared_examples/responses'
require 'shared_examples/verifications'

describe BeProtected::Verification do
  let(:header) { {'Content-Type' => 'application/json'} }
  let(:credentials) { {auth_login: 'account_uuid', auth_password: 'account_token'} }

  describe ".verify" do
    let(:params) { {
        limit: {key: "USD_ID", volume: 585}
      } }
    let(:verification) do
      described_class.new(credentials) do |builder|
        builder.adapter :test do |stub|
          stub.post('/verification', params.to_json)  { |env| [status, header, response] }
        end
      end
    end
    let(:verification_result) { verification.verify(params) }

    subject { verification_result }

    context "when response is successful" do
      let(:status)   { 200 }
      let(:response) { { limit: {
            volume: false, count: false, max: false,
            current_volume: 10585, current_count: 15 }
        } }

      its(:status) { should == 200 }
      its(:error?) { should be_false }
      its(:to_hash) { should == response }

      it_behaves_like "successful response"

      context "when limit was exceeded" do
        let(:response) { { limit: {
            volume: true, count: false, max: true,
            current_volume: 10585, current_count: 15 }
        } }

        its(:passed?) { should be_false }

        context "attributes" do
          subject { verification_result.limit }

          it_behaves_like "limit response attributes"
        end
      end

      context "when limit wasn't exceeded" do
        its(:passed?) { should be_true }

        context "attributes" do
          subject { verification_result.limit }

          it_behaves_like "limit response attributes"
        end
      end

    end

    context "when response has error" do
      let(:status)   { 200 }
      let(:response) { { limit: {
            error: "Cannot verify limits." }
        } }

      its(:status)  { should == 200 }
      its(:passed?) { should be_true }
      its(:error?)  { should be_true }
      its(:error_messages) { should == "Limit: #{response[:limit][:error]}" }
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
  end

end
