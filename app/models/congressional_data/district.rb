class District < ApiData
  # ATTRIBUTES --------------------
  # t.string  :number
  # t.integer :state 
  
  # CACHING -----------------------
  include PoorMansMemecache
  cache_on_keys :state, :number
  
end  
