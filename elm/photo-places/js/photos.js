function getPhotoUrls(placeID, urlPort) {
  var request = {
    placeId: placeID
  };

  var service = new google.maps.places.PlacesService(document.createElement("div"));
  service.getDetails(request, callback);

  function callback(place, status) {
    if (status == google.maps.places.PlacesServiceStatus.OK) {
      var photos = place.photos;
      // width, height don't matter, set elsewhere
      var urls = photos.map(function(photo) {
        return photo.getUrl({'maxWidth': 2000, 'maxHeight': 2000});
      });
      urlPort.send(urls);
    }
  }
}
