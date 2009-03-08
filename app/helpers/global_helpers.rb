module Merb
  module GlobalHelpers
    def login_partial
      '../../slices/merb-auth-slice-password/app/views/exceptions/login'
    end 
    
    def tag_styling( obj )
      if obj.respond_to?( :tag_size )
        str = 'font-size: '
        str << obj.tag_size.to_s
        str << 'em;'
        str
      end  
    end     
  end
end
