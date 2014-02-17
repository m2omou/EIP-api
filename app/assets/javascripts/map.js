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
        for (key in data[0]["result"])
            {  
              var place = data[0]["result"][key];
              var posPlace = new google.maps.LatLng(place["latitude"], place["longitude"]);
              var marker = new google.maps.Marker({
                  position: posPlace,
                  map: map,
                  title:place["name"]
              });
            }
          // alert(data[0]["result"][1]);
          // for(key in data) {
          //   alert(key);
          //   if(data.hasOwnProperty(key)) {
          //     var value = data[key];
          //     for(key2 in value) {
          //       alert(key2);
          //     }
          //   //   //do something with value;
          //   }
          // }          // alert(jQuery.parseJSON(data).toString());
        }
      );


    var marker = new google.maps.Marker({
        position: pos,
        map: map,
        title:"Hello World!"
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
