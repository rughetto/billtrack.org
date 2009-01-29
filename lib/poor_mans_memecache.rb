# Overwrites ActiveRecords #all method but leaves #find(:all) as is to work around cache.
# Builds a series of finders for each column in the table, and selects from @all memory set 
# instead of making a database call. Adds after_save hook to the class, to erase the memory
# cache whenever a record is saved of created
module PoorMansMemecache
  def self.included( ar_class )
    # these sends need to be changed for Ruby 1.9
    ar_class.send(:extend, ClassMethods)
    ar_class.send(:include, InstanceMethods)
    # ###
    ar_class.build_finders( ar_class.columns, ar_class)
    ar_class.class_eval do
      after_save :clear_cache
    end  
  end  
  
  module ClassMethods
    def all
      @all ||= find(:all)
    end 
  
    def clear_cache
      @all = nil
    end   
  
    # method for accessing the cache via any column
    def build_finders( cols, klass )
      cols.each do |col|
        define_method( "#{klass}.find_by_#{col}".to_sym ) do |col_val|
          all.select{|rec| rec.send(col.to_sym) == col_val}   
        end 
      end
    end  
    
  end # ClassMethods  
  
  module InstanceMethods
    def clear_cache
      self.class.clear_cache
    end
  end  # InstanceMethods
  
end # PoorMansMemecache