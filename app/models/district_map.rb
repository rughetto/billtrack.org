class DistrictMap < ActiveRecord::Base
  # ATTRIBUTES --------------------
  # t.string  :distric_id
  # t.string  :zip_main
  # t.string  :zip_plus_four

  # NOTES -------------------------
  # The Ruby API can pull from the zip, but there isn't a 1-1 relationship between zips and districts.
  # Still want to create a map here between zip (5-digit if 1-1, 9-digit otherwise), that way when new
  # members are created, a new api call only has to be created for zips not cached
  
  # There should be a class method for retrievivng via zipcode ... def self.[]( zipcode )
  # There should be a class method also for retrieving all the zipcodes for all the districts via Politicians  
  
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
  
  
  # ZIPCODER
  def validate_zip
    if zipcode_object.valid?
      return true
    else  
      errors.add(:zipcode, zipcode_object.errors)
      return false
    end  
  end  
  
  def zipcode=(str)
    @zipcode = Zipcode.new(str)
    @zipcode.parse
    self[:zip_main] = @zipcode.main
    self[:zip_plus_four] = @zipcode.plus_four
    zipcode_object
  end
  
  def zipcode
    zipcode_object.to_s
  end 
  
  def zipcode_object
    @zipcode ||= zipcode_from_db
  end 
  
  def zip_main=(str)
    raise Zipcode::AccessError, "Zipcode parts must be set with zipcode accessors"
  end 
  
  def zip_plus_four=(str)
    raise Zipcode::AccessError, "Zipcode parts must be set with zipcode accessors"
  end 
  
  private
    def zipcode_from_db
      code = ""
      if self.zip_main
        code << self.zip_main
        code << "-#{self.zip_plus_four}" unless self.zip_plus_four.blank?
      end
      Zipcode.new(code)
    end  
  public  
   
  
end
