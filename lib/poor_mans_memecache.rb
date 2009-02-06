# Overwrites ActiveRecords #all method but leaves #find(:all) as is to work around cache.
# Builds a series of finders for each column in the table, and selects from @all memory set 
# instead of making a database call. Adds after_save hook to the class, to erase the memory
# cache whenever a record is saved of created
module PoorMansMemecache
  def self.included( ar_class )
    ar_class.class_eval do
      extend ClassMethods
      include InstanceMethods
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
      @caches ||= []
      @caches.each do |c|
        instance_variable_set(c, nil)
      end  
    end 
    
    def register_cache( cache_var_name ) # without the starting @ symbol
      @caches ||= []
      @caches << "@#{cache_var_name}"
    end    
    
    # #chache_on_keys add a memory cache keyed on the method names passed into key_arr
    # It will create a class method that is called 'find_on_' followed by a underscored list of passed methods
    # The created method looks at the already memory cached @all instance_variable, and 
    def cache_on_keys(*key_arr)
      # normalize arguments
      if key_arr.class == Array
        key_arr.flatten!
        key = key_arr.join("_")
      elsif key_arr.class == String || key_arr.class == Symbol
        key = key_arr.to_s
        key_arr = [key_arr]
      else
        raise ArgumentError, "passed argument(s), must be a string/symbol or an array of strings/symbols"
      end   
      arg_list = key_arr.map{|k| (k.to_s + "_arg")} 
      tests = []
      key_arr.each_with_index do |val, index|
        tests << "rec.#{val} == #{arg_list[index]}"
      end 
      
      # build the methods
      class_eval %{
        def self.find_on_#{key}(#{arg_list.join(", ")})
          @cache_#{key} ||= {}
          @cache_#{key}[ #{ arg_list.collect{|a| a + '.to_s' }.join(" + '_'+ ")} ] ||= all.select{|rec| #{tests.join(" && ")}}
        end  
        
        # register this cache as something that needs to be deleted when the cache expires
        register_cache('cache_#{key}')  
      }
    end  
    
  end # ClassMethods  
  
  module InstanceMethods
    def clear_cache
      self.class.clear_cache
    end
  end  # InstanceMethods
  
end # PoorMansMemecache