shared_examples "successful response" do
  its(:success?) { should be_true }
  its(:failed?)  { should be_false }
end

shared_examples "failed response" do
  context "when response is faled" do
    let(:status)   { 404 }
    let(:response) { '{"error":"Bad request"}' }

    its(:failed?)  { should be_true }
    its(:status)   { should == 404 }
    its(:error)    { should == "Bad request" }
    its(:success?) { should be_false }
  end
end

shared_examples "unknown response" do
  context "when response is unknown" do
    let(:status)   { 415 }
    let(:response) { nil }

    its(:failed?)  { should be_true }
    its(:status)   { should == 415 }
    its(:error)    { should == "Unknown response. Status is 415." }
    its(:success?) { should be_false }
  end
end
