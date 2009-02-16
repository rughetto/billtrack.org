require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe RelatedBill do
  describe "imports" do
    before(:each) do
      Bill.delete_all
      RelatedBill.delete_all
      @xml = GovtrackerFile.new(:file => "#{Merb.root}/spec/xml/111/bills/h1.xml", :tag => :bill ).parsed_file
      @bill = Bill.create(:congressional_session => '111', :chamber => 'h', :number => '1')
    end  
    
    it "should import from xml without throwing an exception" do
      lambda {RelatedBill.import_set((@xml/:relatedbills), @bill)}.should_not raise_error
    end
    
    it "should import the right number of sponsors" do
      set = RelatedBill.import_set((@xml/:relatedbills), @bill)
      set.size.should == 8
    end  
    
    it "should import all the correct attributes" do
      # <bill relation="rule" session="111" type="hr" number="88" />
      related = RelatedBill.import_set((@xml/:relatedbills), @bill).first
      related.relationship.should == 'rule'
      related.related_bill_id.should be_nil
      related.related_bill_data.should match(/:congressional_session=>"111"/)
      related.bill_id.should == @bill.id
    end
  end
end