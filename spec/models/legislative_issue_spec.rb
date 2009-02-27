require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe LegislativeIssue do
  describe "relationships" do
    it "the class should find the root records" do
      LegislativeIssue.roots.size.should == 2
    end
    
    it "should have a parent" do
      age = LegislativeIssue.find_by_name('Age')
      age.parent.should_not be_nil
    end
    
    it "can have multiple parents" do
      womens_health = LegislativeIssue.find_by_name("Women's Health")
      womens_health.parents.size.should == 2
    end  
      
    it "should have children" do
      abortion = LegislativeIssue.find_by_name('Abortion')
      abortion.children.size.should == 12
    end
  end  

end