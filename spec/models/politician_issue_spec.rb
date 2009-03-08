require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe PoliticianIssue do
  before(:each) do
    PoliticianIssue.delete_all
    PoliticianIssueDetail.delete_all
  end
  
  describe 'validations' do
    before(:each) do
      @pi = PoliticianIssueDetail.new
    end  
    
    it 'should require a issue_id and a politician_id' do
      @pi.session = 111
      @pi.should_not be_valid
      @pi.errors.on(:politician_id).should_not be_nil
      @pi.errors.on(:issue_id).should_not be_nil
    end
  end  
    
  describe "relationships" do
    it 'should have details keyed on the politician_id and issue_id' do
      (1..5).each { PoliticianIssueDetail.make( :politician_id => 1, :issue_id => 1 ) }
      pi = PoliticianIssue.create( :politician_id => 1, :issue_id => 1)
      pi.details.size.should == 5
    end 
    
    it 'should have siblings: PolicitianIssue records with the same politician_id but a different issue_id' do
      PoliticianIssueDetail.make( :politician_id => 1, :issue_id => 1 ) # creates associated parent
      PoliticianIssueDetail.make( :politician_id => 1, :issue_id => 2 ) # creates associated parent
      pi = PoliticianIssue.find_or_create_by( :politician_id => 1, :issue_id => 1) # find a parent
      pi.siblings.size.should == 1
    end  
     
    it 'should have an issue' do
      Issue.delete_all
      i = Issue.create(:name => 'first')
      pi = PoliticianIssue.create(:issue_id => i.id)
      pi.issue.should == i
    end 
     
    it 'should have a politician' do
      Politician.delete_all
      Politician.load_from_file
      p = Politician.first
      pi = PoliticianIssue.create(:politician_id => p.id)
      pi.politician.should == p
    end  
  end
  
  describe "calculating a score" do
    before(:each) do
      CongressionalSession.stub!(:first).and_return( 111 )
      CongressionalSession.stub!(:number_of_sessions).and_return( 5 )
      (1..2).each do |num| 
        PoliticianIssueDetail.add( 
          PoliticianIssueDetail.make_unsaved(
            :politician_id => 1, :issue_id => 1
          ).attributes
        ).save
      end 
      (1..3).each do |num| 
        PoliticianIssueDetail.add( 
          PoliticianIssueDetail.make_unsaved(
            :politician_id => 1, :issue_id => 3
          ).attributes
        ).save
      end 
      # this is true because Sham/Machinist generate the same 'random' numbers
      @highest = PoliticianIssue.find_or_create_by(:politician_id => 1, :issue_id => 1)
      @lowest = PoliticianIssue.find_or_create_by(:politician_id => 1, :issue_id => 2)
    end  
    
    it 'issue_count should be the sum issue_score for the records details' do
      sum = PoliticianIssueDetail.sum(:score, :conditions => {:politician_id => 1, :issue_id => 1})
      @highest.issue_count.should == sum
    end
      
    it 'score should normalize issue_count with maximum issue_count for politican, scaling 1 to 10' do
      @highest.score.should == 10.0
      @lowest.score.should == 1.0
    end  
  end  
end  