require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe LegislativeIssue do
  before(:each) do
    @file = Hpricot.parse(File.open("#{Merb.root}/spec/xml/liv.xml"))
    LegislativeIssue.stub!(:hpricoted).and_return(@file)
  end  
  
  it "should import all from xml" do
    LegislativeIssue.delete_all
    LegislativeIssue.batch_import
    LegislativeIssue.count.should == 55
  end
  
  it "should not add records that already exist" do
    LegislativeIssue.count.should == 55
    LegislativeIssue.batch_import
    LegislativeIssue.count.should == 55
  end 
  
  it "should import the correct number of roots" do
    LegislativeIssue.roots.size.should == 2
  end     
end