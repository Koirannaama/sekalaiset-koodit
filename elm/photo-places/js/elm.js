var node = document.getElementById('main');
var app = Elm.Main.embed(node);
app.ports.getPhotos.subscribe(function (placeID) {
  console.log(placeID)
  getPhotoUrls(placeID/*'ChIJN1t_tDeuEmsRUsoyG83frY4'*/, app.ports.photoUrls);
});

app.ports.placeInput.subscribe(function(input) {
  getSuggestions(input, app.ports.placeSuggestions);
});
