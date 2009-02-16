require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe CommitteeBill do
  describe "imports" do
    before(:each) do
      Bill.delete_all
      Committee.delete_all
      Committee.load_from_file
      CommitteeBill.delete_all
      @xml = GovtrackerFile.new(:file => "#{Merb.root}/spec/xml/111/bills/h1.xml", :tag => :bill ).parsed_file
      @bill = Bill.new(:congressional_session => '111', :chamber => 'h', :number => '1')
    end  
    
    it "should import from xml without throwing an exception" do
      lambda {CommitteeBill.import_set((@xml), @bill)}.should_not raise_error
    end
    
    it "should import the right number of sponsors" do
      set = CommitteeBill.import_set((@xml), @bill)
      set.size.should == 2
    end  
    
    it "should import all the correct attributes" do
      # <committee name="House Appropriations" subcommittee="" activity="Referral" />
      committee = CommitteeBill.import_set((@xml), @bill).first
      committee.committee_name.should match(/Appropriations/)
      committee.activity.should == "Referral"
      committee.committee_id.should be_nil
      committee.bill_id.should == @bill.id
    end
  end  
end