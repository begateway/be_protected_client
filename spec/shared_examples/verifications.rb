shared_examples "limit response attributes" do
  its(:max)    { should == hash_response[:limit][:max] }
  its(:count)  { should == hash_response[:limit][:count] }
  its(:volume) { should == hash_response[:limit][:volume] }
  its(:current_count)  { should == hash_response[:limit][:current_count] }
  its(:current_volume) { should == hash_response[:limit][:current_volume] }
end
