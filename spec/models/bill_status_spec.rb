require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe BillStatus do
  describe "imports" do
    before(:each ) do
      BillStatus.delete_all
      Bill.delete_all
      GovtrackerFile.root_directory = "#{Merb.root}/spec/xml/"
      @bill_xml = GovtrackerFile.new(:file => '111/bills/h1.xml', :tag => :status).parsed_file
      @amend_xml = GovtrackerFile.new(:file => '111/bills.amdt/h1.xml', :tag => :status).parsed_file
      @bill = Bill.create(:congressional_session => '111', :chamber => 'h', :number => '1')
      @amend = Amendment.create(:congressional_session => '111', :chamber => 'h', :number => '1')
      @bill.should_not be_new_record
    end  
    
    it 'should #import_set without raising an error' do
       lambda { BillStatus.import_set(@bill_xml, @bill) }.should_not raise_error
    end  
    
    it 'should import status from bills with all data' do
      set = BillStatus.import_set(@bill_xml, @bill)
      set.size.should == 1
      status = set.first
      status.bill_id.should == @bill.id
      status.chamber.should == 'h'
      status.result.should == 'pass'
      status.method.should == 'roll'
      status.details.should == '46'
      (status.date >= Time.parse("2009-01-28")).should == true
      (status.date <= Time.parse("2009-01-29")).should == true
    end
    
      
    it 'should import status from ammendments with all data' do
      set = BillStatus.import_set(@amend_xml, @amend)
      set.size.should == 1
      status = set.first
      status.bill_id.should == @amend.id
      status.result.should == 'fail'
      (status.date >= Time.parse("2009-01-06")).should == true
      (status.date <= Time.parse("2009-01-07")).should == true
    end  
  end  
end