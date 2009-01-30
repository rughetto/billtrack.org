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
    ar_class.class_eval do
      after_save :clear_cache
      after_destroy :clear_cache
    end
    ar_class.columns.each do |col|
      ar_class.class_eval %{
        def self.find_by_#{col.name}( val )
          all_by_#{col.name}( val ).first   
        end
        
        def self.all_by_#{col.name}( val )
          all.select{|rec| rec.#{col.name} == val }
        end  
      }
    end   
  end  
  
  module ClassMethods
    def all
      @all ||= find(:all)
    end 
  
    def clear_cache
      @all = nil
    end   
  end # ClassMethods  
  
  module InstanceMethods
    def clear_cache
      self.class.clear_cache
    end
  end  # InstanceMethods
  
end # PoorMansMemecache