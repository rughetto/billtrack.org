module Merb
  module GlobalHelpers
    def login_partial
      '../../slices/merb-auth-slice-password/app/views/exceptions/login'
    end 
    
    def tag_styling( obj, min=0.85, max=1.5 )
      if obj.respond_to?( :tag_size )
        str = 'font-size: '
        str << obj.tag_size(min, max).to_s
        str << 'em;'
        str
      end  
    end     
  end
end
