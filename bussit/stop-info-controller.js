app.controller("stopInfoController", function (lineStopLists) {
  'use strict';
  var stopInfo = this;
  stopInfo.routes = {};
  stopInfo.displayedStops = {};
  stopInfo.showRouteStops = selectLineStops;

  lineStopLists.lineStopListsPromise.then(function(lineStops) {
    stopInfo.routes = lineStops;
  });

  function selectLineStops(line) {
    stopInfo.displayedStops = stopInfo.routes[line];
  }
});
