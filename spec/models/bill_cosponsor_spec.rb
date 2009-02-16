require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe BillCoSponsor do
  describe "imports" do
    before(:each) do
      Bill.delete_all
      BillSponsor.delete_all
      @xml = GovtrackerFile.new(:file => "#{Merb.root}/spec/xml/111/bills/h1.xml", :tag => :actions ).parsed_file
      @bill = Bill.new(:congressional_session => '111', :chamber => 'h', :number => '1')
    end  
    
    it "should import from xml without throwing an exception" do
      lambda {BillCoSponsor.import_set((@xml), @bill)}.should_not raise_error
    end
    
    it "should import the right number of sponsors" do
      set = BillCoSponsor.import_set((@xml), @bill)
      set.size.should == 9
    end  
    
    it "should import all the correct attributes" do
      sponsor = BillCoSponsor.import_set((@xml), @bill).first
      sponsor.bill_id.should == @bill.id
      sponsor.politician_id.should be_nil
      sponsor.joined_on.should == Time.parse('2009-01-26')
      sponsor.govtrack_id.should == '400409'
      sponsor[:type].should == 'BillCoSponsor'
    end  
  end
end