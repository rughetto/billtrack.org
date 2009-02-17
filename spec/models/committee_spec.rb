require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Committee do

  describe "import" do
    before(:all) do
      Politician.load_from_file
      Committee.delete_all
      CommitteeMember.delete_all
      NameLookup.delete_all
      GovtrackerFile.root_directory = "#{Merb.root}/spec/xml/"
      Committee.batch_import
    end
    
    it "should batch_import all from file" do
      Committee.count.should == 4
    end
    
    it "should update rather than create existing records" do
      Committee.count.should == 4
      Committee.batch_import # reimport
      Committee.count.should == 4
    end
      
    it "should create the right number of subcommitees" do
      committee = Committee.first
      committee.children.size == 3
    end
      
    it "should create the right number of members" do
      CommitteeMember.count.should == 45
      Committee.first.committee_members.size.should == 20
    end  
    
    it "should import name lookups" do
      NameLookup.count.should == 3
    end  
    
    it "should create a new set for each congress" do
      pending
    end   
  end  
  
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