class District < ActiveRecord::Base
  # ATTRIBUTES --------------------
  # t.string  :number
  # t.integer :state 
  
  # CACHING -----------------------
  include PoorMansMemecache
  
  def self.find_or_create(st, num)
    all.select{|rec| rec.state == st && rec.number == num.to_i }.first || create(:state => st, :number => num)
  end  
  
end  
