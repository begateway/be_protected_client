shared_examples "limit response attributes" do
  its(:max)    { should == response[:limit][:max] }
  its(:count)  { should == response[:limit][:count] }
  its(:volume) { should == response[:limit][:volume] }
  its(:current_count)  { should == response[:limit][:current_count] }
  its(:current_volume) { should == response[:limit][:current_volume] }
end
