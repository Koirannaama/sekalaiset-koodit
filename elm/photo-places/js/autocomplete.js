function getSuggestions(input, suggestionPort) {
  var service = new google.maps.places.AutocompleteService();
  service.getPlacePredictions({ "input": input },
                              processSuggestions);

  function processSuggestions(suggestionData, status) {
    if (status === google.maps.places.PlacesServiceStatus.OK) {
      var suggestions = suggestionData.map(function getDescriptionAndID(sugg) {
        return { description: sugg.description, id: sugg.place_id };
      });
      console.log(suggestions);
      suggestionPort.send(suggestions);
    }
  }
}
