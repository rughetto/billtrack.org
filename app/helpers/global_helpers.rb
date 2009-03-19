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
    
    def icon_parade(max_length=10)
      # grab party info about sponsors
      parade = @bill.sponsors.first ? [ @bill.sponsors.first.party.name ] : []
      @bill.cosponsors.each do |s|
        parade << s.party.name if s.party
      end 
      # build image tags
      html = "<div class='icon_parade'>"
      first_icon = parade.shift
      html << image_tag( "#{first_icon.downcase}_large.png") if first_icon
      (0..([max_length - 2, parade.length - 2].min)).each do |index|
        party = parade[index].downcase
        html << image_tag( "#{parade[index].downcase}_small.png") if ['democrat', 'republican'].include?( party )
      end   
      html << "</div>"
      html
    end   
  end
end
