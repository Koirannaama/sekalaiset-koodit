var node = document.getElementById('main');
var app = Elm.Main.embed(node);
app.ports.getPhotosBySuggestion.subscribe(function (placeID) {
  getPhotosByID(placeID, app.ports.photoUrls);
});

app.ports.getPhotosByFreeText.subscribe(function (text) {
  console.log(text);
  getPhotosByText(text, app.ports.photoUrls)
});

app.ports.placeInput.subscribe(function(input) {
  getSuggestions(input, app.ports.placeSuggestions);
});
