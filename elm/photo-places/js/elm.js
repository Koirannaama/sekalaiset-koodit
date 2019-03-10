require('../main.html');
require('../css/styles.scss');
var autoComplete = require("./autocomplete.js");
var photos = require("./photos.js");

var Elm = require('../elm/photo-places.elm');
var mountNode = document.getElementById('main');

var app = Elm.Main.embed(mountNode);

app.ports.getPhotosBySuggestion.subscribe(function (placeID) {
  photos.getPhotosByID(placeID, app.ports.photoUrls);
});

app.ports.getPhotosByFreeText.subscribe(function (text) {
  console.log(text);
  photos.getPhotosByText(text, app.ports.photoUrls)
});

app.ports.placeInput.subscribe(function(input) {
  autoComplete.getSuggestions(input, app.ports.placeSuggestions);
});
