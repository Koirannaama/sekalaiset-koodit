var node = document.getElementById('main');
var app = Elm.Main.embed(node);
getPhotoUrls('ChIJN1t_tDeuEmsRUsoyG83frY4', app.ports.photoUrl);

app.ports.placeInput.subscribe(function(input) {
  console.log("input: " + input);
  getSuggestions(input, app.ports.placeSuggestions);
});
