module Merb
  module PoliticiansHelper
    def politician_map( politician )
      html = "<script src=\"http://maps.google.com/maps?file=api&amp;v=2&amp;key=#{GoogleMapper.api_key}\"
      type=\"text/javascript\"></script>"
      html << <<-HTML
      <script type="text/javascript">
        //<![CDATA[
          function load() {
             if (GBrowserIsCompatible()) {
               var map = new GMap2(document.getElementById("district_map"));
               map.setCenter(new GLatLng(37.4419, -122.1419), 13);
             }
           }
        //]]>
      </script>
      HTML
      if politician.state
        html << 
        "<script>
          $(document).ready(function() { 
            get_state_map(
              #{politician.state.latitude}, 
              #{politician.state.longitude}, 
              #{politician.state.zoom_level}
            );  
          });
        </script>"
      end
      html  
    end  
  end
end # Merb