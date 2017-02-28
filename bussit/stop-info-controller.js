app.controller("stopInfoController", function ($location, lineStopLists) {
  'use strict';
  var stopInfo = this;
  stopInfo.routes = {};
  stopInfo.displayedStops = {};
  stopInfo.showRouteStops = selectLineStops;
  stopInfo.selectedLine = "";
  stopInfo.selectStop = selectStop;

  lineStopLists.lineStopListsPromise.then(function(lineStops) {
    stopInfo.routes = lineStops;
  });

  function selectLineStops(line) {
    stopInfo.displayedStops = stopInfo.routes[line].stopLists;
  }

  function selectStop(stopCode) {
    console.log(stopCode);
    $location.path(""); // siirrä serviceen
  }
});
