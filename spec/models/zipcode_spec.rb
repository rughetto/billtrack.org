require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Zipcode do
  describe "validations" do
    it "a five digit numeric zipcode should be a valid" do
      Zipcode.new('94102').should be_valid
    end  
    
    it "a five digit non-numeric zipcode should nto be valid" do
      Zipcode.new('941o2').should_not be_valid
    end  
    
    it "a five +4 numeric formated zipcode should be valid" do
      Zipcode.new('94102-1234').should be_valid
    end  
    
    it 'a five +4 digit zip with non-numerics should not be valid' do
      Zipcode.new('941o2-1234').should_not be_valid
    end  
    
    it 'a set of number of a different format should not be valid' do
      Zipcode.new('941023-1234').should_not be_valid
    end  
    
    it 'should require a hyphen for +4 zips' do
      Zipcode.new('94102 1234').should_not be_valid
    end
    
    it 'if a zipcode is not valid it should have ar error message' do
      zip = Zipcode.new('94102 1234')
      zip.should_not be_valid
      zip.errors.should_not be_nil
    end    
    
    it 'if a zipcode is valid it should not have an error message' do
      Zipcode.new('94102-1234').errors.should be_nil
    end  
  end  
  
  describe "parsing" do
    it "should find the main five digit in a valid 5-digit zip" do
      zip = Zipcode.new('94102')
      zip.parse
      zip.main.should == '94102'
    end 
    
    it "should find the main five digit zip in a valid 5 +4 zip" do
      zip = Zipcode.new('94102-1243')
      zip.parse
      zip.main.should == '94102'
    end   
    
    it "should have nil for the plus_four portion of the zip given a valid 5 digit zip" do
      zip = Zipcode.new('94102')
      zip.parse
      zip.plus_four.should == nil
    end
    
    it "should find the four digit extension in a zip given a valid 5 +4 digit zip" do
      zip = Zipcode.new('94102-1243')
      zip.parse
      zip.plus_four.should == '1243'
    end  
  end 
  
  describe "to_s" do
    it "should spit out nil for an invalid zipcode" do
      zip = Zipcode.new('941023-1243')
      zip.to_s.should be_nil
    end
    
    it "should print out the 5 +4 zipcode if it is valid" do
      zip = Zipcode.new('94102-1243')
      zip.to_s.should == '94102-1243'
    end
    
    it "should print out the 5 digit zipcode if it is valid" do
      zip = Zipcode.new('94102')
      zip.to_s.should == '94102'
    end  
  end   
  
end  