function getPhotoUrls(placeID, urlPort) {
  var request = {
    placeId: placeID
  };

  var service = new google.maps.places.PlacesService(document.createElement("div"));
  service.getDetails(request, callback);

  function callback(place, status) {
    if (status == google.maps.places.PlacesServiceStatus.OK) {
      var photos = place.photos;
      // change height to 100%
      var photoUrl = photos[0].getUrl({'maxWidth': 2000, 'maxHeight': 2000});
      urlPort.send(photoUrl);
    }
  }
}
