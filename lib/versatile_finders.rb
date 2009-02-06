module VersatileFinders
  def find_by( hash )
    first(:conditions => hash )
  end  

  def find_or_create_by( hash )
    find_by( hash ) || create( hash )
  end
  
  def find_or_initialize_by( hash )
    find_by( hash ) || new( hash )
  end  
end
  
class ActiveRecord::Base
  extend VersatileFinders
end  