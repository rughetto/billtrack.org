require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe District do
  before(:each) do
    District.delete_all
  end  
  
  it "District.find_or_create should create a record if one isn't found via state and number" do
    District.should_receive(:create)
    District.find_or_create('NV', '3')
  end  
  
  it "District.find_or_create should not create a record if one is found" do
    District.find_or_create('NV', '3')
    District.should_not_receive(:create)
    district = District.find_or_create('NV', '3')
    district.state.should ==  'NV'
  end  
end