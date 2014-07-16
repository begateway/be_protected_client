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
    its(:raw)      { should == response }
  end
end

shared_examples "unknown response" do
  context "when response is not json" do
    let(:status) { 503 }
    let(:response) { '<html><head>
<title>503 Service Temporarily Unavailable</title>
</head><body>
<h1>Service Temporarily Unavailable</h1>
</body>
</html>' }

    its(:failed?)  { should be_true }
    its(:status)   { should == 503 }
    its(:error)    { should == "Response is not JSON. Status is 503." }
    its(:success?) { should be_false }
    its(:raw)      { should == response }
  end
end
