class State < ApiData
  
  # CACHING TABLE INTO MEMORY =====================
  include PoorMansMemecache
  # ensure that order of states is set in cache ...
  class_eval do 
    all(:order => 'name')
  end 
   
end
