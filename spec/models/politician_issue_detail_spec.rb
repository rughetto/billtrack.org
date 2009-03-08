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
      @pi.issue_count = 1
      @pi.should_not be_valid
      @pi.errors.on(:session).should_not be_nil
    end   
    it 'should require a non-zero issue count' do
      @pi.issue_id = 1
      @pi.politician_id = 1
      @pi.session = 111
      @pi.issue_count = 0
      @pi.should_not be_valid
      @pi.errors.on(:issue_count).should_not be_nil
    end  
  end  
  
  describe 'adding a record' do
    before(:each) do
      CongressionalSession.stub!(:first).and_return( 111 )
      CongressionalSession.stub!(:number_of_sessions).and_return( 5 )
      PoliticianIssueDetail.delete_all
      PoliticianIssue.delete_all
      @detail = PoliticianIssueDetail.make
      @added =  PoliticianIssueDetail.add( 
        :politician_id => 1000,
        :politician_role => 'Sponsor',
        :issue_id => 2000,
        :session => 111
      )
    end  
    
    it 'should find or intialize' do
      @found = PoliticianIssueDetail.add( @detail.attributes )
      @found.should_not be_new_record
    end  

    it 'should increment the issue cache' do
      @found = PoliticianIssueDetail.add( @detail.attributes )
      @found.issue_count.should == ( @detail.issue_count + 1 )
      @added.issue_count.should == 1
      @added.issue_count.should == 1
      @added.save.should == true
      @added.reload
      @added.issue_count.should == 1
    end
    
    it 'should generate the parent if it doesn\'t already exist' do
      @added.save
      @added.parent.should_not be_nil
    end  
    
    it 'should save generated parent when record is saved' do
      @added.save
      @added.reload
      @added.parent.should_not be_nil
    end
    
    it 'generated parent should have a non-zero issue_count' do
      @added.save
      @added.reload
      @added.parent.issue_count.should_not == 0
    end  
    
    it 'should recalculate the parent score on save if parent exists' do
      pid = PoliticianIssueDetail.add(
        PoliticianIssueDetail.make_unsaved.attributes
      )
      pid.save
      
      parent = pid.parent
      parent.should_receive(:calculate_score).any_number_of_times
      pid.increment_count
      pid.save
    end  
    
    it 'should recalculate the scores for all the parent\'s siblings' do
      pid = PoliticianIssueDetail.add(
        PoliticianIssueDetail.make_unsaved.attributes
      )
      pid.save
      pid.parent.siblings.each do |s|
        s.should_receive(:calculate_score).any_number_of_times
      end  
      pid.increment_count
      pid.save
    end
      
  end 
  
  describe 'calculating score' do
    before(:all) do
      PoliticianIssueDetail.delete_all
      CongressionalSession.stub!(:first).and_return( 111 )
      CongressionalSession.stub!(:current).and_return( 115 )
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
      CongressionalSession.stub!(:first).and_return( 111 )
      CongressionalSession.stub!(:current).and_return( 115 )
      CongressionalSession.stub!(:number_of_sessions).and_return( 5 )
      
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
  end   
  
  describe 'relationships' do
    before(:each) do
      PoliticianIssue.delete_all
      PoliticianIssueDetail.delete_all
    end  
    
    it 'should have a PoliticianIssue parent' do
      parent = PoliticianIssue.make_unsaved
      detail = PoliticianIssueDetail.add( 
        :politician_id => parent.politician_id, 
        :issue_id => parent.issue_id, 
        :session => 111
      )
      detail.save
      detail.should_not be_new_record
      detail.parent.should_not be_nil
    end  
  end  
end