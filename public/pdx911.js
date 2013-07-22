var markerLayer;
var lastGeoJSON;
var doMarkerPan = true;
var bar;
var panTimeout = [];
var timeoutCounter = 0;
var timeoutLength = 5000;
var markerHistory = 3600; // seconds ago
var currentMarkers = []

function clearTimeouts() {
  $.each(panTimeout, function(i, timeout) {
    clearTimeout(timeout);
  })
  panTimeout = [];
}

function setMarkerTimeout(marker, time) {
  timeoutCounter += 1;
  if (time <= 5000) {
    timeout = setTimeout(function() {
      var foo = marker.feature.geometry.coordinates;
      if (doMarkerPan == true) {
        map.panTo(new L.LatLng(foo[1], foo[0]));
        marker.openPopup();
      }
    }, timeoutCounter * timeoutLength);
    panTimeout.push(timeout);
  }
}
function removeOldMarkers() {
 newMarkers=[]
 for (var i=0; i < currentMarkers.length; i++) {
  var me=currentMarkers[i]
  d=new Date(me.feature.properties.published)
  now=new Date()
  if ((now-d)/1000 > markerHistory) {
    map.removeLayer(me)
  } else {
   newMarkers.push(me);
  }
 }
 currentMarkers = newMarkers;
}

function loadCalls(time) {
  removeOldMarkers();
  time = typeof time !== 'undefined' ? time : 1500;
  url = "/calls/" + time
  $.getJSON(url, function(geojson) {
    lastGeoJSON = geojson;
    if (geojson.features.length > 0) {
      clearTimeouts(); // cancel any pending marker pans
      timeoutCounter = 0;
    }
    markerLayer = new L.geoJson(geojson, {
      onEachFeature: function(feature, layer) {
        marker=layer.bindPopup(feature.properties.html);
        setMarkerTimeout(marker, time);
        currentMarkers.push(marker);
      }
    })
      .addTo(map);
  });
}

function disableAutoPan() {
  doMarkerPan = false;
}
function enableAutoPan() {
  doMarkerPan = true;
}
