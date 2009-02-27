require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Politician do
  before(:all) do
  end
    
  describe "validations" do
      
  end  

  describe "relationships" do
    before(:all) do
      State.load_from_file
      District.delete_all
      Politician.delete_all
      Politician.load_from_file
      IdLookup.delete_all
      @pol = Politician.find_by(:last_name => 'Pelosi')
    end  
    
    it "should have a party" do
      Party.load_from_file
      party = @pol.party
      party.should_not be_nil
      party.class.should == Party
    end  
    
    it "Senators should have many districts" do
      District.load_from_file
      @sen = Politician.find_by(:state => 'CA', :seat => 'Junior Seat')
      @sen.save
      (@sen.districts.size > 1).should == true
    end
      
    it "Representatives should have one district" do
      District.load_from_file
      @pol.district.should_not be_nil
      @pol.district.class.should == District
    end  
    
    it "should have id_lookups" do
      IdLookup.load_from_file
      (@pol.id_lookups.size > 0).should == true
    end
      
    it "should have name_lookups" do 
      @pol.save
      NameLookup.load_from_file
      (@pol.name_lookups.size > 0).should == true
    end
      
    it "should have bill_sponsors" do
      BillSponsor.delete_all
      bill = Bill.create( :congressional_session => '111', :chamber => 's', :number => '1' )
      BillSponsor.create( :bill_id => bill.id, :politician_id => @pol.id )
      @pol.bill_sponsors.size.should == 1 
    end
      
    it "should have sponsored_bills" do
      BillSponsor.delete_all
      bill = Bill.create( :congressional_session => '111', :chamber => 's', :number => '1' )
      BillSponsor.create( :bill_id => bill.id, :politician_id => @pol.id )
      @pol.sponsored_bills.size.should == 1
    end
      
    it "sponsored_bills should not include cosponsored_bills" do
      BillSponsor.delete_all
      bill = Bill.create( :congressional_session => '111', :chamber => 's', :number => '1' )
      bill2 = Bill.create(:congressional_session => '111', :chamber => 'h', :number => '2')
      BillSponsor.create( :bill_id => bill.id, :politician_id => @pol.id )
      BillCoSponsor.create( :bill_id => bill2.id, :politician_id => @pol.id)
      @pol.sponsored_bills.size.should == 1
      @pol.sponsored_bills.first.should == bill
    end
      
    it "should have cosponsored_bills" do
      BillSponsor.delete_all
      bill = Bill.create( :congressional_session => '111', :chamber => 's', :number => '1' )
      BillCoSponsor.create( :bill_id => bill.id, :politician_id => @pol.id)
      @pol.cosponsored_bills.size.should == 1
    end
      
    it "cosponsored_bills should not include sponsored bills" do
      BillSponsor.delete_all
      bill = Bill.create( :congressional_session => '111', :chamber => 's', :number => '1' )
      bill2 = Bill.create(:congressional_session => '111', :chamber => 'h', :number => '2')
      BillSponsor.create( :bill_id => bill.id, :politician_id => @pol.id )
      BillCoSponsor.create( :bill_id => bill2.id, :politician_id => @pol.id)
      @pol.cosponsored_bills.size.should == 1
      @pol.cosponsored_bills.first.should == bill2
    end  
    
  end  

  describe 'naming methods' do
    before(:each) do
      District.delete_all
      Party.delete_all
      District.load_from_file
      Party.load_from_file
      Politician.load_from_file
      @pol = Politician.find_by(:last_name => 'Pelosi')
    end
      
    it '#name should output a string with title, first name and last name' do
      @pol.name.should match(/Representative Nancy Pelosi/i)
    end
     
    it '#names should be an array with a number of permutations of first, middle, last, nick and suffix names' do
      forward_match = false
      backwards_match = false
      @pol.names.each do |name|
        forward_match = true if name.match(/Nancy Pelosi/i)
        backwards_match = true if name.match(/Pelosi, Nancy/i) # failing
      end  
      forward_match.should == true
      backwards_match.should == true 
    end  
      
    it '#constituency should output a string with party name, state and district or seat' do
      @pol.constituency.should match(/Democrat/i)
      @pol.constituency.should match(/CA/i)
      @pol.constituency.should match(/8/) 
    end  
  end  
end