require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe CommitteeMember do
  before(:each) do
    Politician.delete_all
    CommitteeMember.delete_all
  end  

  describe "fuzzy finding" do
    before(:each) do
      @p = Politician.create(:first_name => 'Politician 1', :bioguide_id => '222')
      @p_member = CommitteeMember.create(:committee_id => 1, :politician_id => @p.id)
      @name_member = CommitteeMember.create(:committee_id => 1, :politician_id => nil, :politician_name => "FuzzyName")
    end  
    
    it "should find by committee and politician ids" do 
      member = CommitteeMember.find_fuzzy(:committee_id => 1, :politician => @p, :politician_name => "FuzzyName")
      member.should_not be_nil
      member.should == @p_member
    end  
    
    it "should find by committee id and politician name" do
      member = CommitteeMember.find_fuzzy(:committee_id => 1, :politician => nil, :politician_name => "FuzzyName")
      member.should_not be_nil
      member.should == @name_member
    end  
  end  
  

end