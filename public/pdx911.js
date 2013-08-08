var markerLayer;
var lastGeoJSON;
var doMarkerPan = true;
var bar;
var panTimeout = [];
var timeoutCounter = 0; // counter for calculating pan interval
var timeBetweenPans = 5000;
var markerHistory = 3600; // seconds ago
var currentMarkers = []

function clearTimeouts() {
  $.each(panTimeout, function(i, timeout) {
    //console.log(timeout);
    clearTimeout(timeout);
  })
  panTimeout = new Array;
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
    }, timeoutCounter * timeBetweenPans);
    panTimeout.unshift(timeout);
  }
}
function removeOldMarkers() {
 var newMarkers=[]
 for (var i=0; i < currentMarkers.length; i++) {
  var me=currentMarkers[i]
  d=new Date(me.feature.properties.published)
  now=new Date()
  if ((now-d)/1000 > markerHistory) {
    map.removeLayer(me)
  } else {
   newMarkers.unshift(me);
   me.setOpacity(1.25-(((now-d)/1000)/markerHistory));
  }
 }
 currentMarkers = newMarkers;
 return(currentMarkers);
}

function loadCalls(time) {
  console.log('loadCalls() ' + new Date());
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
        console.log('added feature: ' + feature.id);
        currentMarkers.unshift(marker);
      }
    })
      .addTo(map);
  removeOldMarkers();
  });
  setTimeout(function() {loadCalls(60);},60*1000);
}

function disableAutoPan() {
  doMarkerPan = false;
  $('#togglePan').html('Enable Auto Pan');
}
function enableAutoPan() {
  doMarkerPan = true;
 $('#togglePan').html('Disable Auto Pan');
}

function toggleAutoPan() {
 if (doMarkerPan) {
  disableAutoPan();
 } else { 
  enableAutoPan();
 }
 return(doMarkerPan);
}
