require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe DistrictMap do
  before(:each) do
    DistrictMap.delete_all
    District.delete_all
    District.clear_cache
    @district = DistrictMap.new(:district_id => 3, :zipcode => '94102-1234')
  end  
  describe "validations" do
    it "should require a zipcode" do
      dm = DistrictMap.new(:district_id => 3)
      dm.should_not be_valid
      dm.errors.on(:zipcode).should_not be_nil
    end  
    
    it "should require a valid zipcode" do
      dm = DistrictMap.new(:district_id => 3, :zipcode => '901023')
      dm.should_not be_valid
      dm.zipcode = '94102'
      dm.should be_valid
    end
      
    it "should require a unique combination of district_id, zip_main, and zip_plus_four" do
      @district.save.should == true
      dm = DistrictMap.new(:district_id => @district.district_id, :zipcode => @district.zipcode )
      dm.should_not be_valid
    end  
  end  
  
  describe "importing data" do
    before(:each) do
      @district = District.create(:state => 'CA', :number => 8)
      @zips = DistrictMap.all_from_sunlight_for_district( @district )
    end
      
    it "should import all the records from sunshine for a given district" do
      DistrictMap.should_receive(:all_from_sunlight_for_district).and_return( @zips )
      DistrictMap.import_district_set_from_sunlight( @district )
      DistrictMap.count.should == @zips.size
    end 
    
    it "should not duplicate imported records" do
      DistrictMap.should_receive(:all_from_sunlight_for_district).any_number_of_times.and_return( @zips )
      DistrictMap.import_district_set_from_sunlight( @district )
      original_size = DistrictMap.count
      DistrictMap.import_district_set_from_sunlight( @district )
      DistrictMap.count.should == original_size
    end  
    
    it "should import from all districts in the database" do
      District.create(:state => 'CA', :number => 7)
      District.count.should == 2
      DistrictMap.all_from_sunlight
      (DistrictMap.count > @zips.size).should == true
    end   
  end  
  
  describe "zipcoder" do
    it "should zipcode= should set zip_main and zip_plus_four with a valid zipcode" do
      @district.zip_main.should == '94102'
      @district.zip_plus_four.should == '1234'
    end  
    
    it "should gather the zipcode parts from the database if zipcode is requested but not instantiated" do
      @district.save.should == true
      DistrictMap.first.zipcode.should == '94102-1234'
    end
      
    it "should raise an error if zip_main= or zip_plus_four= are directly accessed" do
      lambda { @district.zip_main = '94102' }.should raise_error
      lambda { @district.zip_plus_four = '1234' }.should raise_error
    end  
  end  

end