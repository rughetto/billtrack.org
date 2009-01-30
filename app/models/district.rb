class District < ActiveRecord::Base
  # ATTRIBUTES --------------------
  # t.string  :number
  # t.integer :state 
  
  # VALIDATIONS -------------------
  def validate
    # must be a unique pair
    limit = new_record? ? 0 : 1
    unless self.class.count(:all, :conditions => {:state => self.state, :number => self.number} ) <= limit
      errors.add_to_base("must have a unique combination of state and district number")
      return false
    end  
  end  
  
  
  # CACHING -----------------------
  include PoorMansMemecache
  cache_on_keys :state, :number
  
  
  # FINDERS ETC -------------------
  # finder method that looks for the unique pair, state and number
  def self.find_or_create(st, num)
    all.select{|rec| rec.state == st && rec.number == num.to_i }.first || create(:state => st, :number => num)
  end  
  
end  
