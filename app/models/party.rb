class Party < ActiveRecord::Base
  # ATTRIBUTES ------------------------------
  # abbreviation - one letter code used by sunlight legislature 
  # name
  # website
  # color - hex color
  
  # VALIDAITONS ----------------------------
  validates_uniqueness_of :abbreviation
  validates_presence_of :abbreviation # can't insist on name since may be coming from Politician object
  
  # CACHING --------------------------------
  include PoorMansMemecache
  
  def self.find_or_create_by_abbreviation(abbrev)
    find_by_abbreviation(abbrev) || create(:abbreviation => abbrev)
  end  

end
