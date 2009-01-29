require File.join( File.dirname(__FILE__), '..', "spec_helper" )
describe Party do
  before(:each) do
    Party.delete_all
    Party.create(:abbreviation => 'D', :name => 'Democrat')
    Party.create(:abbreviation => 'R', :name => 'Republican')
    Party.create(:abbreviation => 'I', :name => 'Independent')
    Party.create(:abbreviation => 'G', :name => 'Green')
  end  

  describe "validations" do
    it "should have a unique abbreviation" do
      Party.new(:abbreviation => 'D', :name => 'new').should_not be_valid
    end  
    it "should have a unique name" do
      Party.new(:name => 'Democrat', :abbreviation => 'N').should_not be_valid
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
      puts found_party.inspect
      found_party.class.should == Party
      found_party.abbreviation.should == 'D'
    end  
  end  
   

end