$(document).ready(function() { 
  $('.district_map').jmap('init', {mapType:'map', logo: false}, function(el, options){
    $(el).jmap('searchAddress', {address: 'California'}, function(options, point) {
      $('.district_map').jmap("moveTo", {mapCenter: [point.y,point.x]});
      $('.district_map').jmap('addMarker', {pointLatLng:[point.y, point.x], pointHTML: 'Address'});
    });
  });
});    