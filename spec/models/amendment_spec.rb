require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Amendment do
  before(:each) do
    Bill.delete_all
    BillAction.delete_all
    BillStatus.delete_all
    BillSponsor.delete_all
    Politician.delete_all
    Politician.load_from_file
    GovtrackerFileSet.root_directory = "#{Merb.root}/spec/xml/"
    GovtrackerFile.root_directory = GovtrackerFileSet.root_directory
    @xml = GovtrackerFile.new(:file => "111/bills.amdt/h1.xml", :tag => :amendment ).parsed_file
  end  
  
  describe "imports" do
    it "#import_data should run without raising an error" do
      lambda { Amendment.import_data(@xml) }.should_not raise_error
    end  
    
    it "should import data for a single record" do
      Amendment.import_data(@xml).class.should == Amendment
      Amendment.count.should == 1
    end
    
    it "imported data should have all the correct information" do
      amdt = Amendment.import_data(@xml)
      amdt.congressional_session.should == '111'
      amdt.chamber.should == 'h'
      amdt.number.should == '1'
      amdt.sequence.should == '1'
      (amdt.xml_updated_at >= Time.parse('2009-01-21') ).should == true
      (amdt.xml_updated_at <= Time.parse('2009-01-23') ).should == true
      (amdt.introduced_at >= Time.parse('2009-01-05')).should == true
      (amdt.introduced_at <= Time.parse('2009-01-07')).should == true
      amdt.short_title.should == 'Amendment to elect officers of the House of Representatives.'
      amdt.title.should == amdt.short_title
      amdt.parent_name.should match(/:number=>"1"/)
      amdt.parent_id.should be_nil
    end
      
    it "should import related statuses" do
      amdt = Amendment.import_data(@xml)
      BillStatus.count.should == 1
    end  
    
    it "should import related actions" do
      amdt = Amendment.import_data(@xml)
      BillAction.count.should == 3
    end
      
    it "should import related sponsors" do
      amdt = Amendment.import_data(@xml)
      BillSponsor.count.should == 1
      BillSponsor.first.govtrack_id.should == '400315'
    end 
     
    it "should batch import from the amendment directory" do 
      set = Amendment.import_set
      set.size.should == 2
    end  
  end  

end  