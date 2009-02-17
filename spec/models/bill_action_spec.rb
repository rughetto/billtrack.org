require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe BillAction do
  before(:each) do
    Bill.delete_all
    BillAction.delete_all
    @xml = GovtrackerFile.new(:file => "#{Merb.root}/spec/xml/111/bills.amdt/h1.xml", :tag => :actions ).parsed_file
    @bill = Bill.new(:congressional_session => '111', :chamber => 'h', :number => '1')
  end
  
  describe "#import" do
    it "should import from xml without throwing an exception" do
      lambda {BillAction.import((@xml/:action).first, @bill)}.should_not raise_error
    end  
    
    it 'imported BillActions should import all the available attributes' do
      action =  BillAction.import((@xml/:action).first, @bill)
      action.bill_id.should be_nil
      action[:type].should be_nil
      action.reference.should == 'CR H6'
      action.reference_label.should == 'consideration'
      action.description.should match(/A001/)
      action.action_time.class.should == Time
      (action.action_time >= Time.parse("2009-01-06") ).should == true
      (action.action_time <= Time.parse("2009-01-07") ).should == true
    end  
    
    it 'imported BillVotes should have the additional attributes for that model' do
      vote = BillVote.import( (@xml/:vote).first, @bill )
      vote.vote_result.should == 'fail'
      vote.vote_method.should == "by voice vote"
    end
  end  
    
  describe "#import set" do
    it 'should perform without exception' do
      lambda { BillAction.import_set( @xml, @bill ) }.should_not raise_error
    end  
    
    it 'should create BillActions' do
      set = BillAction.import_set( @xml, @bill )
      set.collect(&:class).should include( BillAction )
    end  
    
    it 'should create BillVotes' do
      set = BillAction.import_set( @xml, @bill )
      set.collect(&:class).should include( BillVote )
    end
      
    it 'should create the right number of actions and votes' do
      set = BillAction.import_set( @xml, @bill )
      set.size.should == 3
      set.select{|rec| rec.class == BillAction}.size.should == 2
      set.select{|rec| rec.class == BillVote}.size.should == 1
    end  
    
    it "should import set for existing bill" do
      @bill.save
      @bill.should_not be_new_record
      set = BillAction.import_set( @xml, @bill )
      set.collect(&:bill_id).should == [@bill.id, @bill.id, @bill.id]
    end
  end  
end