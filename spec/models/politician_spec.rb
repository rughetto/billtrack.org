require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Politician do
  before(:all) do
    @sunlight ||=  Sunlight::Legislator.all_for(:address => '94102')
    @sunlight.should_not be_nil
    @rep = @sunlight[:representative]
    @junior = @sunlight[:junior_senator]
  end
    
  before(:each ) do
    Politician.delete_all
    Party.delete_all
    District.delete_all
    Party.clear_cache
    District.clear_cache
  end
  
  describe "validations" do
    before(:each) do
      @pol = Politician.new_from_sunlight( @rep )
    end  
    
    it "should not be valid without a bioguide_id" do 
      @pol.bioguide_id = nil
      @pol.should_not be_valid
    end
      
    it "should not be valid without a unique bioguide_id" do
      @pol.save
      Politician.new_from_sunlight(@rep).should_not be_valid
    end  
    
    it "should valid with a unique, non-empty bioguide_id" do
      @pol.should be_valid
    end
      
  end  

  describe "relationships" do
    before(:each) do
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
  end  

  describe "data imports from sunlight" do
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
  end
end