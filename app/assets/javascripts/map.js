   var map;

   function initialize() {
    var mapOptions = {
      zoom: 16,
      disableDefaultUI: true,
      zoomControl: true
    };


    map = new google.maps.Map(document.getElementById('map-canvas'),
      mapOptions);

    // Try HTML5 geolocation
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(function(position) {
        var lat = position.coords.latitude
        var lng = position.coords.longitude
        var lat = "48.858093"
        var lng = "2.294694"
        var pos = new google.maps.LatLng(lat, lng);
        var url = "places.json?latitude=" + pos.lat() + "&longitude=" + pos.lng() + "&limit=100" + "&radius=2000";
        $.getJSON(
          url,
          { latitude: lat, longitude: lng },
          function(data) {
            var infoWindows = new Array();
            for (key in data["result"]["places"])
            {  
              var place = data["result"]["places"][key];
              var posPlace = new google.maps.LatLng(place["latitude"], place["longitude"]);
              var iconVar = "http://maps.google.com/mapfiles/marker.png";
              if (place["icon"] != "")
               iconVar = place["icon"];

             var marker = new google.maps.Marker({
              position: posPlace,
              map: map,
              icon: iconVar,
              title: place["name"]
            });

             var contentString = '<a href="places/' + place["id"] + '" style="color: blue;">' + place["name"] + "</a>";

             var infowindow = new google.maps.InfoWindow({
              content: contentString
            });
             infoWindows.push(infowindow);

             google.maps.event.addListener(marker, 'click', function(innerMarker, innerInfowindow) {
              return function() {

                for (keyWindow in infoWindows)
                  infoWindows[keyWindow].close();
                innerInfowindow.open(map, innerMarker);
              }  
            } (marker, infowindow));
           }
         }
         );


   var marker = new google.maps.Marker({
    position: pos,
    map: map,
    icon: "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
    title: "You are here!"
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
