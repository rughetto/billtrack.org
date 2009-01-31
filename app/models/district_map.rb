# The main job of the district map in to cache locally the relationship between zipcodes and districts
# If a map is complex (ie. a zip has many districts), then the other sunshine methods should be called
# When user data like the full +4 zip is known, another record should be added to this set

class DistrictMap < ActiveRecord::Base
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
  
  # BATCH IMPORTING FROM SUNLIGHT
  def self.import_district_set_from_sunlight( district )
    set = []
    bad_districts = []
    begin
      all_from_sunlight_for_district( district ).each do |zip|
        dm = DistrictMap.new(:district_id => district.id, :zipcode => zip)
        if dm.valid? 
          dm.save
          set << dm
        end  
      end
    rescue
      bad_districts << district
    end  
    bad_districts 
  end  
  
  def self.all_from_sunlight_for_district( district )
    Sunlight::District.zipcodes_in(district.state, district.number)
  end  
  
  def self.all_from_sunlight
    bad_districts = []
    District.all.each do |district|
      bad_districts << import_district_set_from_sunlight( district )
    end  
    bad_districts.flatten!
    Merb.logger.error("DistrictMap import from districts failed to import from districts with the following ids:
    #{bad_districts.collect(&:id).inspect}")
    bad_districts
  end  
  
  # this goes directly to the sql and in two queries makes zips with more than one district complex = true
  def self.set_complex_mapping
    ids = self.find_by_sql("
      SELECT *
      FROM     (SELECT *,  COUNT( district_id ) AS district_count
      		FROM district_maps 
      		GROUP BY district_maps.zip_main
      		ORDER BY district_count DESC) AS district_counter
      WHERE district_count > 1
    ").collect(&:id)
    id_str = ids.map{|i| "'#{i}'"}.join(', ')
    ActiveRecord::Base.connection.execute "UPDATE district_maps SET complex = 1 WHERE id IN (#{id_str})"
  end  
   
  
end
