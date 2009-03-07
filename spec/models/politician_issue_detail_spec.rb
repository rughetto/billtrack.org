require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe PoliticianIssueDetail do
  before(:each) do
    
  end  
  
  describe 'validation' do
    before(:each) do
      @pi = PoliticianIssueDetail.new
    end  
    it 'should require a congerssional session' do
      @pi.issue_id = 1
      @pi.politician_id = 1
      @pi.should_not be_valid
      @pi.errors.on(:session).should_not be_nil
    end  
    it 'should require a issue_id and a politician_id' do
      @pi.session = 111
      @pi.should_not be_valid
      @pi.errors.on(:politician_id).should_not be_nil
      @pi.errors.on(:issue_id).should_not be_nil
    end  
  end  
  
  describe 'adding a record' do
    before(:each) do
      CongressionalSession.stub!(:first).and_return( 111 )
      CongressionalSession.stub!(:number_of_sessions).and_return( 5 )
      PoliticianIssueDetail.delete_all
      @detail = PoliticianIssueDetail.make
    end  
    
    it 'should find or intialize' do
      @found = PoliticianIssueDetail.add( @detail.attributes )
      @found.should_not be_new_record
    end  

    it 'should increment the issue cache' do
      @found = PoliticianIssueDetail.add( @detail.attributes )
      @found.issue_count.should == ( @detail.issue_count + 1 )
    end
  end 
  
  describe 'calculating score' do
    before(:all) do
      PoliticianIssueDetail.delete_all
      CongressionalSession.stub!(:first).and_return( 111 )
      CongressionalSession.stub!(:number_of_sessions).and_return( 5 )
      (1..10).each do |num|
        PoliticianIssueDetail.make
      end 
      @highest = PoliticianIssueDetail.create(
        :politician_role => 'Sponsor',
        :politician_id => 15,
        :session => 115, 
        :issue_id => 1, 
        :issue_count => 12
      )
      @lowest = PoliticianIssueDetail.create(
        :politician_role => 'CoSponsor',
        :politician_id => 15,
        :session => 111, 
        :issue_id => 2, 
        :issue_count => 1
      )
      # 
    end  
    
    it 'should find the max issue count for a given politician' do
      @highest.max_issue_count_for_politician.should == 12
      @lowest.max_issue_count_for_politician.should == 12
    end  
    
    it 'should have an issue score between 1 and 10' do
      @highest.issue_score.should == 10
      @lowest.issue_score.should == 1
    end  
    
    it 'should have a session score should be < 0 and >= 1' do
      @highest.session_score.should == 1
      (@lowest.session_score > 0 && @lowest.session_score < 1).should == true
    end  
    
    it 'should have a sponsor score of 0.5 or 1' do
      @highest.sponsor_score.should == 1
      @lowest.sponsor_score.should == 0.5
    end  
    
    it 'should have a score after saving' do
      @highest.reload
      @highest.score.should_not be_blank
    end  
    
    it 'score should be on a scale of 1 to 10' do
      @highest.score.should == 10
      @lowest.score.should == 1
    end  
    
    it 'for identical session and issue count, a bill sponsor should get a higher score than a bill cosponsor' do
      @coed = PoliticianIssueDetail.new( @highest.attributes )
      @coed.politician_id = 30
      @coed.politician_role = 'CoSponsor'
      @coed.save
      (@coed.score < @highest.score).should == true
    end
  end   
  
end