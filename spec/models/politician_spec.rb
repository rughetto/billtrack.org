require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Politician do
  before(:all) do
    @sunlight ||=  Sunlight::Legislator.all_for(:address => '94102')
    @sunlight.should_not be_nil
    @rep = @sunlight[:representative]
    @junior = @sunlight[:junior_senator]
  end
    
  describe "validations" do
      
  end  

  describe "relationships" do
    before(:all) do
      State.load_from_file
      District.delete_all
      Politician.delete_all
      IdLookup.delete_all
      @pol = Politician.new_from_sunlight( @rep )
    end  
    
    it "should have a party" do
      party = @pol.party
      party.should_not be_nil
      party.class.should == Party
    end  
    
    it "Senators should have many districts" do
      District.create(:state => 'CA', :number => '1')
      @sen = Politician.new_from_sunlight(@junior)
      @sen.save
      @sen.districts.size.should == 2
    end
      
    it "Representatives should have one district" do
      @pol.district.should_not be_nil
      @pol.district.class.should == District
    end  
    
    it "should have id_lookups" do
      (@pol.id_lookups.size > 0).should == true
    end
      
    it "should have name_lookups" do 
      @pol.save
      Politician.extract_names
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

  describe "data imports from sunlight" do
    before(:each ) do
      Politician.delete_all
      Party.delete_all
      District.delete_all
      Party.clear_cache
      District.clear_cache
    end
    
    it "build a record from a Sunlight::Legislator without raising an exception" do
      lambda do 
        Politician.new_from_sunlight( @rep )
      end.should_not raise_error  
    end  
    
    it "should build a new Representative from a Sunlight::Legislator with a title that is 'Rep'" do
      Politician.new_from_sunlight( @rep ).class.should == Representative
    end  
    
    it "should build a new Senator from a Sunlight::Legislator with a title that is not 'Rep'" do
      Politician.new_from_sunlight( @junior ).class.should == Senator
    end  
    
    it "should add a district object if one doesn't exist" do 
      District.all.size.should == 0
      poli = Politician.new_from_sunlight( @rep )
      poli.save
      District.all.size.should == 1
    end  
    
    it "should not add a district object if one already exists" do
      Politician.new_from_sunlight( @rep ).save
      District.all.size.should == 1
      new_poli = Politician.new_from_sunlight(@rep)
      new_poli.district.should_not be_new_record
    end  
    
    it "should create a party from the abbreviation if one doesn't exist" do
      Party.all.size.should == 0
      Politician.new_from_sunlight( @rep ).save
      Party.all.size.should == 1
    end
      
    it "should not create a pary if the party already exists" do
      Politician.new_from_sunlight( @rep ).save
      Party.all.size.should == 1
      Politician.new_from_sunlight( @junior ).save
      Party.all.size.should == 1
    end  
    
    it "should bulk import all records from the active sunlight api" do
      sunlights = Politician.all_active_from_sunlight
      Politician.should_receive(:all_active_from_sunlight).and_return( sunlights )
      Politician.count.should == 0
      records = Politician.import_from_sunlight
      sunlights.size.should == records.size
    end  
  end
  
  describe 'id lookups' do
    it 'should extract ids from database if id fields are defined in the table' do
      IdLookup.delete_all
      Politician.load_from_file
      lambda { Politician.extract_ids }.should_not raise_error
      if Politician.columns.collect(&:name).include?( 'bioguide_id' )
        pol = Politician.find(56)
        pol.id_lookups.size.should == 5
        [:votesmart_id, :fec_id, :govtrack_id, :crp_id].each do |id_type|
          this_id = pol.id_lookups.select{|rec| rec.id_type == id_type.to_s }.first
          pol.send( id_type.to_sym ).should == this_id.additional_id
        end
      end  
    end  
  end  

  describe 'naming methods' do
    before(:each) do
      District.delete_all
      Party.delete_all
      District.load_from_file
      Party.load_from_file
      @pol = Politician.new_from_sunlight( @rep )
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
      
    it 'Politician.extract_names should add lookups for all strings in #names' do
      NameLookup.delete_all
      Politician.delete_all
      @pol.save
      Politician.extract_names
      NameLookup.count.should == @pol.names.size
    end  
    
    it '#constituency should output a string with party name, state and district or seat' do
      @pol.constituency.should match(/Democrat/i)
      @pol.constituency.should match(/CA/i)
      @pol.constituency.should match(/8/) 
    end  
  end  
end