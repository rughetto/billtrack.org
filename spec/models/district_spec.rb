require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe District do
  before(:each) do
    District.delete_all
    District.clear_cache
  end  
  
  describe "caching on keys" do
    it "should find a record by state and number" do
      District.find_or_create_by(:state => 'NV', :number => '3')
      District.count.should == 1
      District.all.size.should == 1
      set = District.find_on_state_number('NV', 3)
      set.class.should == Array
      set.first.should_not be_nil
    end    
  end  
    
end