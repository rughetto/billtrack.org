require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe BillIssue do
  before(:each) do
    PoliticianIssue.delete_all
    BillSponsor.delete_all
    Bill.delete_all
    Issue.delete_all
    BillIssue.delete_all
    @bill = Bill.create( :congressional_session => '111', :chamber => 's', :number => '14' )
    @bill.should_not be_new_record
    @bill_issue = BillIssue.new( :bill_id => @bill.id )
  end  

  it 'should have an issue_name accessor' do
    lambda { @bill_issue.issue_name }.should_not raise_error
    lambda { @bill_issue.issue_name = 'something'}.should_not raise_error
  end  
  
  it 'should create or find an issue by issue_name when that variable is not empty' do
    issue_1 = Issue.create(:name => 'first issue')
    bill_issue = BillIssue.create(:issue_name => 'first issue', :bill_id => 4)
    bill_issue.issue_id.should == issue_1.id
    bill_issue_2 = BillIssue.create(:issue_name => 'second issue', :bill_id => 4)
    bill_issue_2.issue_id.should_not be_nil
    bill_issue_2.issue.name.should == 'second issue'
  end
  
  it '#has_permissions? should be true if an administrator' do
    @bill_issue.user_permissions = [:admin]
    @bill_issue.has_permissions?.should == true
  end  
  
  it '#has_permissions? should be true if has issue administration priveliges' do
    @bill_issue.user_permissions = [:issues]
    @bill_issue.has_permissions?.should == true
  end   
  
  it '#has_permissions? should not be true if not a general or issue administrator' do
    @bill_issue.user_permissions = [:politicians]
    @bill_issue.has_permissions?.should == false
  end  
  
  it 'should create an approved issue when user is an administrator' do
    bill_issue = BillIssue.new(:issue_name => 'first', :bill_id => @bill.id )
    bill_issue.user_permissions = [:admin]
    bill_issue.save
    bill_issue.issue.status.should == :approved
  end
    
  it 'should create an approved issue when user has permissions to administer issue' do
    bill_issue = BillIssue.new(:issue_name => 'first', :bill_id => @bill.id )
    bill_issue.user_permissions = [:issues]
    bill_issue.save
    bill_issue.issue.status.should == :approved
  end
    
  it 'should create a suggested issue when user does not have admin permissions for issues' do
    bill_issue = BillIssue.new(:issue_name => 'first', :bill_id => @bill.id)
    bill_issue.user_permissions = []
    bill_issue.save
    bill_issue.issue.status.should == :suggested
  end  
  
  it 'should create an issue with information about who suggested it if that is provided' do
    bill_issue = BillIssue.new(:issue_name => 'first', :bill_id => @bill.id)
    bill_issue.user_permissions = []
    bill_issue.suggested_by = 144
    bill_issue.save
    bill_issue.issue.suggested_by.should == 144
  end  
  
  it 'should populate user data using permissions_data=' do
    bill_issue = BillIssue.new(:issue_name => 'first', :bill_id => @bill.id)
    Member.delete_all
    member = Member.new(:roles => 'admin', :username => 'someone')
    member.save(false)
    bill_issue.permissions_data = member
    bill_issue.user_permissions.should == [:admin]
    bill_issue.suggested_by.should_not be_nil
  end  
  
  it 'should find or create related politician_issue records if status is approved' do
    BillCoSponsor.create( :politician_id => 1, :bill_id => @bill.id )
    BillSponsor.create( :politician_id => 2, :bill_id => @bill.id )
    BillSponsor.create( :politician_id => 3, :bill_id => @bill.id )
    bill_issue = BillIssue.new(:issue_name => 'first', :bill_id => @bill.id )
    bill_issue.user_permissions = [:admin]
    bill_issue.save
    PoliticianIssueDetail.count.should == 3
    PoliticianIssue.count( :conditions => {:type => nil} ).should == 3
  end  
end