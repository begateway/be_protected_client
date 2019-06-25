require 'spec_helper'
require 'shared_examples/responses'
require 'shared_examples/verifications'
require 'shared_examples/connection_failed'

describe BeProtected::Verification do
  let(:header) { {'Content-Type' => 'application/json'} }
  let(:credentials) { {auth_login: 'account_uuid', auth_password: 'account_token'} }
  let(:verification) { described_class.new(credentials) }

  before { BeProtected::Configuration.url = 'http://example.com' }

  describe ".verify" do
    let(:params) { {
        limit: {key: "USD_ID", volume: 585},
        white_black_list: {ip: "127.0.7.10", email: "john@example.com"},
        rules: {ip: "127.0.0.8", card_number: "4200000000000000"}
      } }
    let(:verification_result) { verification.verify(params) }

    subject { verification_result }

    before do
      stub_request(:post, "http://example.com/verification")
        .with(body: params.to_json)
        .to_return(status: status, body: response, headers: header)
    end

    context "when response is successful" do
      let(:status) { 200 }
      let(:hash_response) do
        {
          limit: {
            volume: false, count: false, max: false,
            current_volume: 10585, current_count: 15
          },
          white_black_list: { ip: "absent", email: "white" },
          rules: {
            'parent account' => {'alias 1' => {'Transaction amount more than 100 EUR' => 'skipped'}},
            'child account'  => {'alias 5' => {'Transaction amount more than 90 USD'  => 'passed'}}
          }
        }
      end
      let(:response) { hash_response.to_json }

      its(:status) { should == 200 }
      its(:error?) { should be false }
      its(:to_hash) { should == hash_response }

      it_behaves_like "successful response"

      context "when has_action skip_3ds" do
        let(:response) do
          {
            rules: {
              'system account' => { 'alias 7' => { 'Transaction amount more than 90 USD'  => 'skip_3ds' } }
            }
          }.to_json
        end

        it "returns true on has_action? call" do
          expect(verification_result.has_action?('skip_3ds')).to be_truthy
          expect(verification_result.rules.has_action?('skip_3ds')).to be_truthy

          expect(verification_result.has_action?('skip_3ds_fun')).to_not be_truthy
          expect(verification_result.rules.has_action?('skip_3ds_fun')).to_not be_truthy
        end
      end

      context "when limit was exceeded" do
        let(:hash_response) do
          { limit: { volume: true, count: false, max: true, current_volume: 10585, current_count: 15 } }
        end
        let(:response) { hash_response.to_json }

        its(:passed?) { should be false }

        context "attributes" do
          subject { verification_result.limit }

          it_behaves_like "limit response attributes"
        end
      end

      context "when limit wasn't exceeded" do
        its(:passed?) { should be true }

        context "attributes" do
          subject { verification_result.limit }

          it_behaves_like "limit response attributes"
        end
      end

      context "when white_black_list includes passed item in blacklist" do
        let(:response) { { white_black_list: { ip: "black", email: "absent" } }.to_json }

        its(:passed?) { should be false }

        context "attributes" do
          subject { verification_result.white_black_list }

          its(:ip)    { should == "black" }
          its(:email) { should == "absent" }
        end
      end

      context "when white_black_list includes passed item in white list" do
        let(:response) { { white_black_list: { ip: "white", email: "black" } }.to_json }

        its(:passed?) { should be true }

        context "attributes" do
          subject { verification_result.white_black_list }

          its(:ip)    { should == "white" }
          its(:email) { should == "black" }
        end
      end

      context "when white_black_list does not include passed item in any list" do
        let(:response) { { white_black_list: { ip: "absent", email: "absent" } }.to_json }

        its(:passed?) { should be true }

        context "attributes" do
          subject { verification_result.white_black_list }

          its(:ip)    { should == "absent" }
          its(:email) { should == "absent" }
        end
      end

      context "when at least one rule was 'reject'" do
        let(:hash_response) do
          {
            rules: {
              'parent account' => {
                'alias 1' => {'Transaction amount more than 100 EUR' => 'review'},
                'alias 2' => {'Transaction amount more than 400 EUR' => 'reject'}},
              'child account'  => {'alias 5' => {'Transaction amount more than 90 USD'  => 'skipped'}}
            }
          }
        end
        let(:response) { hash_response.to_json }

        its(:passed?) { should be false }

        context "attributes" do
          subject { verification_result.rules }
          its(:to_hash) { should == hash_response[:rules] }
        end
      end

      context "when all rules was not 'reject'" do
        its(:passed?) { should be true }

        context "attributes" do
          subject { verification_result.rules }
          its(:to_hash) { should == hash_response[:rules] }
        end
      end

    end

    context "when response has error" do
      let(:status)   { 200 }
      let(:response) do
        {
          limit: { error: "Cannot verify limits." },
          white_black_list: { error: "Cannot verify white_black_list." }
        }.to_json
      end
      let(:hash_response) do
        {
          limit: {volume: nil, count: nil, max: nil, current_volume: nil, current_count: nil} ,
          white_black_list: {}
        }
      end

      its(:status)  { should == 200 }
      its(:passed?) { should be true }
      its(:error?)  { should be true }
      its(:error_messages) do
        should == "Limit: Cannot verify limits. WhiteBlackList: Cannot verify white_black_list."
      end
      its(:to_hash) { should == hash_response }
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
    it_behaves_like "connection failed"
  end

  describe ".white_black_list_verify" do
    let(:value) { 'any value' }
    let(:params) { { white_black_list: {value: value} } }

    subject { verification.white_black_list_verify(value) }

    before do
      stub_request(:post, "http://example.com/verification")
        .with(body: params.to_json)
        .to_return(status: status, body: response, headers: header)
    end

    context "when value is included in whitelist" do
      let(:status)   { 200 }
      let(:response) { {white_black_list: {value: "white"}}.to_json  }

      it { should == 'white' }
    end

    context "when value is included in blacklist" do
      let(:status)   { 200 }
      let(:response) { {white_black_list: {value: "black"}}.to_json  }

      it { should == 'black' }
    end

    context "when value is absent in white and black list" do
      let(:status)   { 200 }
      let(:response) { {white_black_list: {value: "absent"}}.to_json  }

      it { should == 'absent' }
    end

    context "when response is error" do
      let(:status)   { 200 }
      let(:response) { {white_black_list: { error: "Cannot verify white_black_list." }}.to_json  }

      it { should be_nil }
    end

    context "when response is unknown" do
      let(:status)   { 503 }
      let(:response) { 'unknown response' }

      it { should be_nil }
    end
  end
end
