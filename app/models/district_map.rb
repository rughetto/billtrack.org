class DistrictMap < ActiveRecord::Base
  # ATTRIBUTES --------------------
  # t.string  :distric_id
  # t.integer :zipcode # 5 digit if 1-1 relationship, otherwise 5-4 digits
  
  # NOTES -------------------------
  # The Ruby API can pull from the zip, but there isn't a 1-1 relationship between zips and districts.
  # Still want to create a map here between zip (5-digit if 1-1, 9-digit otherwise), that way when new
  # members are created, a new api call only has to be created for zips not cached
  
  # There should be a class method for retrievivng via zipcode ... def self.[]( zipcode )
  # There should be a class method also for retrieving all the zipcodes for all the districts via Politicians  
  
  
end
