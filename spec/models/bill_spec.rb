require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Bill do
  describe "imports" do
    before(:each) do
      Bill.delete_all
      Amendment.load_from_file # just load amendments so assocciations can be made during import
      BillAction.delete_all
      BillStatus.delete_all
      BillSponsor.delete_all
      BillSubject.delete_all
      CommitteeBill.delete_all
      Politician.delete_all
      Politician.load_from_file
      RelatedBill.delete_all
      GovtrackerFileSet.root_directory = "#{Merb.root}/spec/xml/"
      GovtrackerFile.root_directory = GovtrackerFileSet.root_directory
      @xml = GovtrackerFile.new(:file => "111/bills/h1.xml", :tag => :bill ).parsed_file
    end  

    describe "imports" do
      it "#import_data should run without raising an error" do
        lambda { 
          Bill.import_data(@xml) 
        }.should_not raise_error
      end  

      it "should import data for a single record" do
        Bill.import_data(@xml).class.should == Bill
      end

      it "should import a full set" do
        set = Bill.import_set
        set.size.should == 2
      end
      
      it "imported data should have all the correct information" do
        bill = Bill.import_data(@xml)
        bill.congressional_session.should == '111'
        bill.chamber.should == 'h'
        bill.number.should == '1'
        (bill.xml_updated_at >= Time.parse('2009-01-31') ).should == true
        (bill.xml_updated_at <= Time.parse('2009-02-01') ).should == true
        (bill.introduced_at >= Time.parse('2009-01-25')).should == true
        (bill.introduced_at <= Time.parse('2009-01-26')).should == true
        bill.short_title.should == 'American Recovery and Reinvestment Act of 2009'
        bill.title.should match(/Making supplemental appropriations/)
      end

      it "should import related statuses/votes" do
        bill = Bill.import_data(@xml)
        BillVote.count.should == 1
      end  

      it "should import related actions" do
        bill = Bill.import_data(@xml)
        BillAction.count.should == 12
      end

      it "should import related sponsors" do
        bill = Bill.import_data(@xml)
        BillSponsor.count.should == 10
      end 
      
      it "should import related committee_bills" do
        bill = Bill.import_data(@xml)
        CommitteeBill.count.should == 2
      end
      
      it "should import related bill_subjects" do
        bill = Bill.import_data(@xml)
        BillSubject.count.should == 10
      end
      
      it "should update related ammendments" do
        bill = Bill.import_data(@xml)
        bill.amendments.size.should == 12
      end  
      
      it "should import related bills" do
        bill = Bill.import_data(@xml)
        RelatedBill.count.should == 6
      end    
    end
  end  
  
  describe "text helpers" do
    before(:each) do
      @bill = Bill.new(:congressional_session => '111', :chamber => 'hr', :number => '13')
    end  
    
    it '#title_short should be #short_title if #short_title is not blank' do
      @bill.title = "Long title"
      @bill.short_title = 'Short title'
      @bill.title_short.should == @bill.short_title
    end  
    
    it '#title_short should be #title if #short_title is blank' do
      @bill.title = "Long title"
      @bill.short_title = ''
      @bill.title_short.should == @bill.title
      @bill.short_title = nil
      @bill.title_short.should == @bill.title
    end  
    
    it '#split_chamber should capitalize the chamber and seperate each letter with a period' do
      @bill.split_chamber.should == 'H.R.'
    end
      
    it '#id_number should include the #split_chamber and the bill #number' do
      @bill.id_number.should match( Regexp.new(@bill.split_chamber) )
      @bill.id_number.should match( Regexp.new(@bill.number) )
    end  
    
  end  
end