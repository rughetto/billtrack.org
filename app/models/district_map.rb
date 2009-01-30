class DistrictMap < ActiveRecord::Base
  # ATTRIBUTES --------------------
  # t.integer  :distric_id
  # t.string  :zip_main
  # t.string  :zip_plus_four
  # t.boolean  :complex

  # NOTES -------------------------
  # The Ruby API can pull from the zip, but there isn't a 1-1 relationship between zips and districts.
  # Still want to create a map here between zip (5-digit if 1-1, 9-digit otherwise), that way when new
  # members are created, a new api call only has to be created for zips not cached
  
  # There should be a class method for retrievivng via zipcode ... def self.[]( zipcode )
  # There should be a class method also for retrieving all the zipcodes for all the districts via Politicians  
  
  # EXTENSIONS & LIBRARIES
  has_zipcode_accessor # from /lib/zipcoder
  
  
  # VALIDATIONS
  def validate
    validate_zip && validate_unique_mapping
  end  
  
  def validate_unique_mapping
    # must be a unique pair
    limit = new_record? ? 0 : 1
    unless self.class.count(:all, 
      :conditions => {  :district_id => self.district_id, 
                        :zip_main => self.zip_main,
                        :zip_plus_four => self.zip_plus_four } 
      ) <= limit
      errors.add_to_base("must have a unique combination of district and and nine-digit zipcode")
      return false
    end  
  end  
  
   
  
end
