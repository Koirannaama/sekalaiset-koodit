export function getSuggestions(input, suggestionPort) {
  if ( input !== "") {
    var service = new google.maps.places.AutocompleteService();
    service.getPlacePredictions({ "input": input },
                                processSuggestions);
  }
  else {
    suggestionPort.send([]);
  }

  function processSuggestions(suggestionData, status) {
    if (status === google.maps.places.PlacesServiceStatus.OK) {
      var suggestions = suggestionData.map(function getDescriptionAndID(sugg) {
        return { description: sugg.description, id: sugg.place_id };
      });
      suggestionPort.send(suggestions);
    }
  }
}
