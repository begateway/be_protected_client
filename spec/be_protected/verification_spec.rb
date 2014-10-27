require 'spec_helper'
require 'shared_examples/responses'
require 'shared_examples/verifications'
require 'shared_examples/connection_failed'

describe BeProtected::Verification do
  let(:header) { {'Content-Type' => 'application/json'} }
  let(:credentials) { {auth_login: 'account_uuid', auth_password: 'account_token'} }

  describe ".verify" do
    let(:params) { {
        limit: {key: "USD_ID", volume: 585},
        blacklist: {ip: "127.0.7.10", email: "john@example.com"},
        rules: {ip: "127.0.0.8", card_number: "4200000000000000"}
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
      let(:response) { {
          limit: {
            volume: false, count: false, max: false,
            current_volume: 10585, current_count: 15
          },
          blacklist: {
            ip: false, email: false
          },
          rules: {
            'parent account' => {'alias 1' => {'Transaction amount more than 100 EUR' => 'skipped'}},
            'child account'  => {'alias 5' => {'Transaction amount more than 90 USD'  => 'passed'}}
          }
        } }

      its(:status) { should == 200 }
      its(:error?) { should be false }
      its(:to_hash) { should == response }

      it_behaves_like "successful response"

      context "when limit was exceeded" do
        let(:response) { { limit: {
            volume: true, count: false, max: true,
            current_volume: 10585, current_count: 15 }
        } }

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

      context "when blacklist includes passed item" do
        let(:response) { { blacklist: { ip: true, email: false } } }

        its(:passed?) { should be false }

        context "attributes" do
          subject { verification_result.blacklist }

          its(:ip)    { should be true }
          its(:email) { should be false }
        end
      end

      context "when blacklist does not include passed item" do
        let(:response) { { blacklist: { ip: false, email: false } } }

        its(:passed?) { should be true }

        context "attributes" do
          subject { verification_result.blacklist }

          its(:ip)    { should be false }
          its(:email) { should be false }
        end
      end

      context "when at least one rule was 'reject'" do
        let(:response) { { rules: {
              'parent account' => {
                'alias 1' => {'Transaction amount more than 100 EUR' => 'review'},
                'alias 2' => {'Transaction amount more than 400 EUR' => 'reject'}},
              'child account'  => {'alias 5' => {'Transaction amount more than 90 USD'  => 'skipped'}}
            } } }

        its(:passed?) { should be false }

        context "attributes" do
          subject { verification_result.rules }
          its(:to_hash) { should == response[:rules] }
        end
      end

      context "when all rules was not 'reject'" do
        its(:passed?) { should be true }

        context "attributes" do
          subject { verification_result.rules }
          its(:to_hash) { should == response[:rules] }
        end
      end

    end

    context "when response has error" do
      let(:status)   { 200 }
      let(:response) { {
          limit: { error: "Cannot verify limits." },
          blacklist: { error: "Cannot verify blacklist." }
        } }
      let(:hash_response) { {
          limit: {volume: nil, count: nil, max: nil, current_volume: nil, current_count: nil} ,
          blacklist: {}
        } }

      its(:status)  { should == 200 }
      its(:passed?) { should be true }
      its(:error?)  { should be true }
      its(:error_messages) { should == "Limit: #{response[:limit][:error]} Blacklist: #{response[:blacklist][:error]}" }
      its(:to_hash) { should == hash_response }
    end

    it_behaves_like "failed response"
    it_behaves_like "unknown response"
    it_behaves_like "connection failed"
  end

end
