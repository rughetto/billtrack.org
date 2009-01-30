require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe District do
  before(:each) do
    District.delete_all
    District.clear_cache
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
  
  describe "validations" do
    it "should require unique combination of state and number" do
      District.find_or_create('NV', '3')
      District.new(:state => 'NV', :number => '3').should_not be_valid
    end  
  end
  
  describe "caching on keys" do
    it "should find a record by state and number" do
      District.find_or_create('NV', '3')
      District.count.should == 1
      District.all.size.should == 1
      set = District.find_on_state_number('NV', 3)
      set.class.should == Array
      set.first.should_not be_nil
    end    
  end  
    
end