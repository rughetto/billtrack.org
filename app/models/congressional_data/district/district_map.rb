# The main job of the district map in to cache locally the relationship between zipcodes and districts
# If a map is complex (ie. a zip has many districts), then the other sunshine methods should be called
# When user data like the full +4 zip is known, another record should be added to this set

class DistrictMap < ApiData
  # ATTRIBUTES --------------------
  # t.integer  :distric_id
  # t.string  :zip_main
  # t.string  :zip_plus_four
  # t.boolean  :complex

  attr_accessor :district_count # used for custom mysql query
  
  # RELATIONSHIPS
  belongs_to :district
  
  # EXTENSIONS & LIBRARIES
  has_zipcode_accessor # from /lib/zipcoder
  
  # include PoorMansMemecache
  # cache_on_keys :district_id, :zipcode
  
  
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
