 var map;

function initialize() {
  var mapOptions = {
    zoom: 15
  };
  map = new google.maps.Map(document.getElementById('gmap'),
      mapOptions);

  // Try HTML5 geolocation
  if(navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
      var pos = new google.maps.LatLng(position.coords.latitude,
                                       position.coords.longitude);

      var url = "places.json?latitude=" + pos.lat() + "&longitude=" + pos.lng() + "&limit=100" + "&radius=2000";

	$.getJSON(
        url,
        {latitude: position.coords.latitude, longitude: position.coords.longitude},
        function(data) {
          for (key in data["result"]["places"])
            {  
              var place = data["result"]["places"][key];
              var posPlace = new google.maps.LatLng(place["latitude"], place["longitude"]);
              var marker = new google.maps.Marker({
                  position: posPlace,
                  map: map,
                  title:place["name"]
              });
            }
        }
      );


    var marker = new google.maps.Marker({
        position: pos,
        map: map,
	icon: "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
        title:"You are here!"
    });
      // var infowindow = new google.maps.InfoWindow({
      //   map: map,
      //   position: pos
      // });

      map.setCenter(pos);
    }, function() {
      handleNoGeolocation(true);
    });
  } else {
    // Browser doesn't support Geolocation
    handleNoGeolocation(false);
  }
}

function handleNoGeolocation(errorFlag) {
  if (errorFlag) {
    var content = 'Error: The Geolocation service failed.';
  } else {
    var content = 'Error: Your browser doesn\'t support geolocation.';
  }

  var options = {
    map: map,
    position: new google.maps.LatLng(60, 105),
    content: content
  };

  var infowindow = new google.maps.InfoWindow(options);
  map.setCenter(options.position);
}

google.maps.event.addDomListener(window, 'load', initialize);
