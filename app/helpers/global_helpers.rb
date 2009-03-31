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
    
    def party_star( party, opts={:class => 'left', :size => 'small'} )  
      image_tag( "#{party.name.downcase}_#{opts[:size]}.png", :class => opts[:class]) if ['democrat', 'republican'].include?( party.name.downcase ) 
    end    
    
    def politician_map( politician )  
      if politician.class == Representative 
        color = politician.party.color if politician.party
        color = defined?(color) ? color : '#666'
        district_map( politician.district, color )
      else
        state_map( politician.state )
      end    
    end
    
    def district_map( district, color='#666' )   
      html = "<script src=\"http://maps.google.com/maps?file=api&amp;v=2&amp;key=#{GoogleMapper.api_key}\"
      type=\"text/javascript\"></script>"
      
      html << <<-HTML    
      <script type="text/javascript">
        //<![CDATA[
          function map_initialize() {
             if (GBrowserIsCompatible()) { 
               var map = new GMap2(document.getElementById("district_map"));
               map.setCenter(new GLatLng(#{district.latitude}, #{district.longitude}), #{district.state.zoom_level} );
               #{ district.js_outline ? district.js_outline.gsub('#ff0000', color).gsub('"#000000",0,0.0', "\"#{color}\", 2, 0.5") : '' }; 
               map.setUIToDefault();
             }
           }
        //]]>
      </script> 
      <script>
       $(document).ready(function() { 
          map_initialize();  
        });
      </script>    
      HTML
      html
    end
    
    def state_map( state )
      html = "<script src=\"http://maps.google.com/maps?file=api&amp;v=2&amp;key=#{GoogleMapper.api_key}\"
      type=\"text/javascript\"></script>"
      html << <<-HTML
      <script type="text/javascript">
        //<![CDATA[
          function map_initialize() {
             if (GBrowserIsCompatible()) {
               var map = new GMap2(document.getElementById("district_map"));
               map.setCenter(new GLatLng(#{state.latitude}, #{state.longitude}), #{state.zoom_level});
             }
           }
        //]]>
      </script>
      <script>
       $(document).ready(function() { 
          map_initialize();  
        });
      </script>
      HTML
      html  
    end   
  end
 
   
end
