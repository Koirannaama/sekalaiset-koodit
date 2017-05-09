function getPhotoUrls(placeID, urlPort) {
  var request = {
    placeId: placeID
  };

  var service = new google.maps.places.PlacesService(document.createElement("div"));
  service.getDetails(request, callback);

  function callback(place, status) {
    var urls = [];
    var photos = place.photos;
    if (status == google.maps.places.PlacesServiceStatus.OK
        && photos !== undefined) {
      // width, height don't matter, set elsewhere
      urls = photos.map(function(photo) {
        return photo.getUrl({'maxWidth': 2000, 'maxHeight': 2000});
      });
    }
    urlPort.send(urls);
  }
}
