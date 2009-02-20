function get_state_map(latitude, longitude, zoom_level) {
  $('.district_map').jmap('init', {mapType:'map', logo: false}, function(el, options){
    $('.district_map').jmap("moveTo", {mapCenter: [latitude, longitude], mapZoom: zoom_level});
  });
};
    