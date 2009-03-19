require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Issue do
  before(:each) do
    Issue.delete_all
  end  
  
  describe 'validations:' do
    it 'should have a name' do
      issue = Issue.new
      issue.should_not be_valid
      issue.errors.on(:name).should_not be_nil
    end  
    
    it 'should have a unique name' do
      Issue.create(:name => 'unique')
      issue = Issue.new(:name => 'unique')
      issue.should_not be_valid
      issue.errors.on(:name).should_not be_nil
    end  
    
    it 'name uniqueness should not be case-sensitive' do
      Issue.create(:name => 'unique')
      issue = Issue.new(:name => 'UniQue')
      issue.should_not be_valid
      issue.errors.on(:name).should_not be_nil
    end 
    
    it 'should downcase the name before saving' do
      issue = Issue.create(:name => 'UNIQUE')
      issue.name.should == 'unique'
    end  
    
    it 'should strip white space around the name before saving' do
      issue = Issue.create(:name => ' unique ')
      issue.name.should == 'unique'
    end  
  end  

  describe 'status machine:' do
    before(:each) do
      @issue = Issue.new(:name => 'statusize')
    end  
    
    it 'default status should be "suggested"' do
      @issue.status.should == :suggested
    end  
    
    it 'status should always be delivered as a symbol' do
      @issue.status.class.should == Symbol
      @issue.status = 'suggested'
      @issue.status.class.should == Symbol
      # check to make sure it is saving properly as a string and not as a packed symbol
      @issue.save
      @issue.reload
      @issue.status.should == :suggested
      @issue.status.class.should == Symbol
    end  
    
    it '#status_index should be a number that identifies the index of the status value in the class array statuses' do
      @issue.status_index.should == 0
      @issue.status = 'suggested'
      @issue.status_index.should == 0
      @issue.status = 'approved'
      @issue.status_index.should == 1
    end
      
    it 'status should advance if not at end of array' do
      @issue.status = 'suggested'
      @issue.advance_status
      @issue.status.should == :approved
    end
      
    it 'status should not advance if at end of the array' do
      @issue.status = 'approved'
      @issue.advance_status
      @issue.status.should == :approved
    end
    
    it 'after status is advanced it should be a symbol' do
      @issue.advance_status!
      @issue.reload
      @issue.status.should == :approved
    end  
  end  

  describe 'counter cache:' do
    it 'usage count should increase when a new bill_issue refers to the tag' do
      bi = BillIssue.create( :issue_name => 'new issue', :bill_id => 1 )
      issue = bi.issue
      issue.reload
      issue.usage_count.should == 1
      BillIssue.create( :issue_name => 'new issue', :bill_id => 2 )
      issue.reload
      issue.usage_count.should == 2
    end  
  end
  
  describe 'tag sizing:' do
    before(:each) do
      @biggest = Issue.create(:name => 'biggest')
      @biggest[:usage_count] = 20
      @biggest.status = 'approved'
      @biggest.save(false)
      @smallest = Issue.create(:name => 'smallest')
      @smallest[:usage_count] = 1
      @smallest.status = 'approved'
      @smallest.save(false)
      @middle = Issue.create(:name => 'middle')
      @middle[:usage_count] = 10
      @middle.status = 'approved'
      @middle.save(false)
    end
      
    it 'should have a highest_usage_count of 20' do
      Issue.highest_usage_count.should == 20
    end
      
    it 'should have a lowest_usage_count of 1' do
      Issue.lowest_usage_count.should == 1
    end
      
    it 'should have a count_span of 19' do
      Issue.count_span.should == 19
    end  
      
    it 'issue with the smallest usage_count should have a tag_size of the minimum' do
      @smallest.tag_size( 1, 2 ).should == 1
      @smallest.tag_size( 0.85, 1.5).should == 0.85
    end
      
    it 'issue with the largest usage_count should have a tag_size of the maximum' do
      @biggest.tag_size( 1, 2).should == 2
      @biggest.tag_size( 0.85, 1.5).should == 1.5
    end  
  end  
  
  describe 'creation from a string' do
    it 'Issue.from_string should create n number of tags from comma seperated string' do
      Issue.from_string('first, second').size.should == 2
    end  
    
    it 'Issue.from_string should find issues that already exist' do
      Issue.from_string('first, second')
      Issue.from_string('second, third').size.should == 2
      Issue.count.should == 3
    end  
  end  
  
  describe 'relationships' do
    before(:each) do
      Bill.delete_all
      BillIssue.delete_all
      PoliticianIssue.delete_all
      @issue = Issue.create(:name => 'new')
      @bills = []
      (1..5).each do |num|
        @bills << bill = Bill.make
        bill.sponsors << Politician.make
        bill.save
        BillIssue.create( :bill_id => bill.id, :issue_id => @issue.id)
      end  
    end  
    
    it 'should have bill_issues' do
      @issue.bill_issues.size.should == 5
    end
      
    it 'should have bills' do
      @issue.bills.size.should == 5
    end
      
    it 'should have politician_issues' do
      @issue.politician_issues.size.should == 5
    end
    
    it 'should have politicians' do
      @issue.politicians.size.should == 5
    end  
  end  
  
  describe 'merging issues' do
    before(:each) do
      BillIssue.delete_all
      PoliticianIssue.delete_all
      @base = Issue.create(:name => 'parks')
      @extra = Issue.create(:name => 'parks district')
      (1..3).each do |num|
        bill = Bill.make
        bill.sponsors << Politician.make
        BillIssue.create(:bill_id => bill.id, :issue_id => @base.id)
        
        bill = Bill.make
        bill.sponsors << Politician.make
        BillIssue.create(:bill_id => bill.id, :issue_id => @extra.id)
        
        if num == 1
          BillIssue.create(:bill_id => bill.id, :issue_id => @base.id)
        end  
      end
      @extra.reload
      @base.reload
    end  
    
    it 'should have methods for Issue.merge, issue.merge_into_self and issue.merge_into_other' do
      Issue.respond_to?(:merge).should == true
      @base.respond_to?(:merge_into_self).should == true
      @base.respond_to?(:merge_into_other).should == true
    end  
    
    it 'should delete the merged issue' do
      @base.merge_into_self(@extra)
      lambda { Issue.find(@extra.id) }.should raise_error
    end
    
    it 'should recompute the usage_count based of the merged issue\'s related records' do
      @base.merge_into_self(@extra)
      @base.reload
      @base.usage_count.should == 6 # @base had 4, @extra had three, there was one duplicate so 6!
    end
      
    it 'should assign bill_issues from the merged issue to the mergee issue' do
      @base.merge_into_self(@extra)
      @base.reload
      @base.bill_issues.size.should == 6 # same calculations as above
    end
      
    it 'should assign politician_issues_details from the merged issue to the mergee issue' do
      @base.merge_into_self( @extra )
      @base.reload
      @base.politician_issue_details.size.should == 6 # there is one politician per bill, so same as above
    end
  end  
  
end