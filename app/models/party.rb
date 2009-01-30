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
  # if the app moves to memcache we can do this ...
  # def self.find_by_abbreviation(abbrev)
  #   if Merb::Cache[:memcache].exists?("party_#{abbrev}", {:abbreviation => abbrev})
  #     Merb::Cache[:memcache].read("party_#{abbrev}", {:abbreviation => abbrev})
  #   else
  #     result = super(abbrev)
  #     Merb::Cache[:memcache].write("party_#{abbrev}", result, {:abbreviation => abbrev})
  #     result
  #   end
  # end  
  # but with file store the record is being saved as its #to_s interpretation, 
  # can be used to save text calculations like politican on member name
  # so this module is used instead
  include PoorMansMemecache
  
  def self.find_or_create_by_abbreviation(abbrev)
    find_by_abbreviation(abbrev) || create(:abbreviation => abbrev)
  end  

end
