export function getPhotosByID(placeID, urlPort) {
  var request = {
    placeId: placeID
  };
  runIDSearch(request, handlePlace);

  function handlePlace(place, status) {
    var photos = place.photos;
    var urls = getUrls(status, photos);
    urlPort.send(urls);
  }
}

export function getPhotosByText(text, urlPort) {
  var req = {
    query: text
  };
  runTextSearch(req, getUrlsFromPlaces);

  function getUrlsFromPlaces(places, status) {
    var urls = places
      .map(function(place) {
        return getUrls(status, place.photos);
      })
      .reduce(function(sumUrlList, urlList) {
        return sumUrlList.concat(urlList);
      })
    urlPort.send(urls);
  }
}

function getUrls(status, photoData) {
  var photosAvailable = status == google.maps.places.PlacesServiceStatus.OK
                        && photoData !== undefined;

  if (photosAvailable) {
    var urls = photoData.map(function(photo) {
      // width, height don't matter, set elsewhere
      return photo.getUrl({'maxWidth': 2000, 'maxHeight': 2000});
    });
    return urls;
  }
  else {
    return [];
  }
}

function runIDSearch(request, callback) {
  var service = new google.maps.places.PlacesService(document.createElement("div"));
  service.getDetails(request, callback);
}

function runTextSearch(request, callback) {
  var service = new google.maps.places.PlacesService(document.createElement("div"));
  service.textSearch(request, callback);
}