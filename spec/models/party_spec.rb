require File.join( File.dirname(__FILE__), '..', "spec_helper" )
describe Party do
  before(:each) do
    Party.delete_all
    Party.clear_cache
    Party.create(:abbreviation => 'D', :name => 'Democrat')
    Party.create(:abbreviation => 'R', :name => 'Republican')
    Party.create(:abbreviation => 'I', :name => 'Independent')
    Party.create(:abbreviation => 'G', :name => 'Green')
  end  

  describe "validations" do
    it "should have a unique abbreviation" do
      Party.new(:abbreviation => 'D', :name => 'new').should_not be_valid
    end  
    it "should be valid with a unique abbreviation" do
      Party.new(:name => "Peace and Freedom", :abbreviation =>  "P").should be_valid
    end  
  end  

  describe "caching" do
    it "Party.find_by_abbreviation should not throw exception" do
      lambda do 
        Party.find_by_abbreviation('D')
      end.should_not raise_error  
    end
    
    it "Party.find_by_abbreviation should find the right record" do
      found_party = Party.find_by_abbreviation('D')
      found_party.class.should == Party
      found_party.abbreviation.should == 'D'
    end 
    
    it "Party.find_by_abbreviation should cache the result in memory" do
      Party.all
      Party.should_not_receive(:find)
      Party.all
    end
  end  
  
  it "Party.find_or_create_by_abbreviation should create a record when necessary" do
    Party.should_receive(:create)
    Party.find_or_create_by_abbreviation('P')
  end  
  
  it "Party.find_or_create_by_abbreviation should not create a record when it exists" do
    Party.find_or_create_by_abbreviation('P')
    Party.should_not_receive(:create)
    Party.find_or_create_by_abbreviation('P')
  end
end