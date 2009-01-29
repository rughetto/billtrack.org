class District < ActiveRecord::Base
  # ATTRIBUTES --------------------
  # t.string  :state
  # t.integer :number
  # t.string  :zipcode
  
  # NOTES -------------------------
  #   zipcodes don't have a one to one relationship between districts, so more data 
  #   or user selection is required to determine the district from user data
  
  #  Create a def self.[]( zipcode method) if nothing is returned (locally) then query sunlight labs api
  #  and store it for future use
  #  Also can batch pull information from district data on representatives
  
end
