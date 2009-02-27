require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Committee do
  describe "relationships" do
    it "should have a parent if it is a subcommittee" do 
      Committee.first(:conditions => "NOT ISNULL( parent_id )").parent.should_not be_nil
    end  
    
    it "should have children if it is a committee" do
      # assumes that an arbitrary committee in the xml test file will have subcommittees
      Committee.first(:conditions => "ISNULL( parent_id )").children.should_not be_blank
    end  
  end  

end