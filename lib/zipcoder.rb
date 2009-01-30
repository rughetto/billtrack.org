module Zipcoder
  module ActiveRecordMethods
    def has_zipcode_accessor
      include Zipcoder::InstanceMethods
    end  
  end
  
  module InstanceMethods
    def validate_zip
      if zipcode_object.valid?
        return true
      else  
        errors.add(:zipcode, zipcode_object.errors)
        return false
      end  
    end  

    def zipcode=(str)
      @zipcode = Zipcode.new(str)
      @zipcode.parse
      self[:zip_main] = @zipcode.main
      self[:zip_plus_four] = @zipcode.plus_four
      zipcode_object
    end

    def zipcode
      zipcode_object.to_s
    end 

    def zipcode_object
      @zipcode ||= zipcode_from_db
    end 

    def zip_main=(str)
      raise Zipcode::AccessError, "Zipcode parts must be set with zipcode accessors"
    end 

    def zip_plus_four=(str)
      raise Zipcode::AccessError, "Zipcode parts must be set with zipcode accessors"
    end 

    private
      def zipcode_from_db
        code = ""
        if self.zip_main
          code << self.zip_main
          code << "-#{self.zip_plus_four}" unless self.zip_plus_four.blank?
        end
        Zipcode.new(code)
      end  
    public
  end      
end 
 
ActiveRecord::Base.send(:extend, Zipcoder::ActiveRecordMethods)