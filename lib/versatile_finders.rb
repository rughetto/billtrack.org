module VersatileFinders
  def find_by( hash )
    first(:conditions => hash )
  end  
  
  def find_all_by( hash )
    first(:conditions => hash )
  end  

  def find_or_create_by( hash )
    find_by( hash ) || create( hash )
  end
  
  def find_or_initialize_by( hash )
    find_by( hash ) || new( hash )
  end  
  
  # this is used for bridging the multi-database gap. It appends _test in custom finder_sql when testing.
  # could be changed for different database setup, with a case structure for each env, or just append env 
  def table_environment
    Merb.env == 'test' ? '_test' : ''
  end  
end
  
class ActiveRecord::Base
  extend VersatileFinders
end  