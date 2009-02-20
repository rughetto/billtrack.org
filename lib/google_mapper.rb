class GoogleMapper
  
  def self.api_key
    if Merb.env == 'production'
      'ABQIAAAABeYBq_RBHX8zH3h9eRIULxQxRnJ4Q2Zc2rji2sbmhJunADIP6xTaw-hBugO0VZ33vtupBaChuKR5bg'
    else
      'ABQIAAAABeYBq_RBHX8zH3h9eRIULxT-ZTKVLgdLz0ZRRJYP7ttYbtpFeBQxMOT8XSoW3gvdQqx-7gYRCs5f0Q'
    end
  end   
  
  # EXAMPLE FROM GOVTRACK_US
  # <script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAsrOexgmxnPO4u3qqssNz6BTSWu0oDPXlD672f64CK_i4O7ZO8RTJr2ghyYddfWwwA2du8CiKUg3szQ" type="text/javascript"></script>
  # <script src="/scripts/gmap-wms.js"></script>   
  # <script type="text/javascript">
  # var map;
  # 
  # if (!GBrowserIsCompatible()) {
  #   //alert("This page uses Google Maps, which is unfortunately not supported by your browser.");
  # } else {
  #   var WMS_URL = 'http://www.govtrack.us/perl/wms-cd.cgi?';
  #   var G_MAP_LAYER_FILLED = createWMSTileLayer(WMS_URL, "cd-filled,district=NJ12", null, "image/gif", null, null, null, .25);
  #   var G_MAP_LAYER_OUTLINES = createWMSTileLayer(WMS_URL, "cd-outline,district=NJ12", null, "image/gif", null, null, null, .66, "Data from GovTrack.us");
  #   var G_MAP_OVERLAY = createWMSOverlayMapType([G_NORMAL_MAP.getTileLayers()[0], G_MAP_LAYER_FILLED, G_MAP_LAYER_OUTLINES], "Overlay");
  # 
  #   document.getElementById("googlemap").style.height = (screen.height - 485) + "px";
  #   map = new GMap2(document.getElementById("googlemap"));
  #   map.enableContinuousZoom()
  #   map.removeMapType(G_SATELLITE_MAP);
  #   map.addMapType(G_MAP_OVERLAY);
  #   map.addControl(new GLargeMapControl());
  #   //map.addControl(new GMapTypeControl());
  #   //map.addControl(new GOverviewMapControl());
  #   map.addControl(new GScaleControl());
  #   map.setMapType(G_MAP_OVERLAY);
  # 
  #   map.setCenter(new GLatLng(40.377457, -74.4983525), 9);
  #   createMarker(-74.4983525, 40.377457, 'NJ', '12');
  # }
  # 
  # function createMarker(x, y, s, d) {
  #   var marker = new GMarker(new GPoint(x, y));
  #   GEvent.addListener(marker, "click", function() {
  #     if (d == 0) d = "At Large";
  #     marker.openInfoWindowHtml("This is " + s + "'s district " + d + "!");
  #   });
  #   map.addOverlay(marker);
  # }
  
  # EXAMPLE FROM GOOGLE MAPS API
  # <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  #   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
  # <html xmlns="http://www.w3.org/1999/xhtml">
  #   <head>
  #     <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
  #     <title>Google Maps JavaScript API Example</title>
  #     <script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAABeYBq_RBHX8zH3h9eRIULxT-ZTKVLgdLz0ZRRJYP7ttYbtpFeBQxMOT8XSoW3gvdQqx-7gYRCs5f0Q"
  #       type="text/javascript"></script>
  #     <script type="text/javascript">
  # 
  #     //<![CDATA[
  # 
  #     function load() {
  #       if (GBrowserIsCompatible()) {
  #         var map = new GMap2(document.getElementById("map"));
  #         map.setCenter(new GLatLng(37.4419, -122.1419), 13);
  #       }
  #     }
  # 
  #     //]]>
  #     </script>
  #   </head>
  #   <body onload="load()" onunload="GUnload()">
  #     <div id="map" style="width:500px;height:300px"></div>
  #   </body>
  # </html>
  # 
end  