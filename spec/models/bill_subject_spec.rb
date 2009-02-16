require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe BillSubject do
  describe "imports" do
    before(:each) do
      LegislativeIssue.delete_all
      Bill.delete_all
      BillSubject.delete_all
      @xml = GovtrackerFile.new(:file => "#{Merb.root}/spec/xml/111/bills/h1.xml", :tag => :actions ).parsed_file
      @bill = Bill.create(:congressional_session => '111', :chamber => 'h', :number => '1')
    end  
    
    it "should import from xml without throwing an exception" do
      lambda {BillSubject.import_set((@xml), @bill)}.should_not raise_error
    end
    
    it "should import the right number of subjects" do
      set = BillSubject.import_set((@xml), @bill)
      set.size.should == 10
    end  
    
    it "should add legislative issues if they are not found" do
      BillSubject.import_set((@xml), @bill)
      (LegislativeIssue.count > 0).should == true
    end  
  end
end  