require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Issue do
  describe 'validations:' do
    it 'should have a unique name' do
      Issue.create(:name => 'unique')
      issue = Issue.new(:name => 'unique')
      issue.should_not be_valid
      issue.errors.on(:name).should_not be_nil
    end  
  end  

  describe 'status machine:' do
    before(:each) do
      Issue.delete_all
      @issue = Issue.new
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

  describe 'counter cache and tag sizing:' do
    it 'usage count should increase when a new bill_issue refers to the tag'
    it 'after the issue is saved the '
  end  
  
end