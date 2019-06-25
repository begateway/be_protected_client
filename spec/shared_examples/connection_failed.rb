shared_examples "connection failed" do
  context "when connection is failed" do
    let(:status) { 500 }
    let(:message)  { "Connection was failed." }
    let(:response) { nil }

    before { expect(Faraday).to receive(:new).and_raise(Faraday::Error, message) }

    its(:failed?)  { should be true }
    its(:status)   { should == 500 }
    its(:error)    { should == message }
    its(:success?) { should be false }
  end
end
