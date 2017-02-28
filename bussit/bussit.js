
var app = angular.module("bussiApp", ["ngRoute"]);
app.config(function($routeProvider) {
  'use strict';
  $routeProvider
  .when("/", {
    templateUrl: "monitor.htm",
    controller: "monitorController"
  })
  .when("/stops", {
    templateUrl: "stop-info.htm",
    controller: "stopInfoController"
  });
});

app.service("stopNames", function($http) {
  this.currentStop = "Sammonkatu 47 (4517)";
  this.stopNamePromise = getStopNames();

  function getStopNames() {
    var stopsApiUrl = "http://data.itsfactory.fi/journeys/api/1/stop-points";

    var stopNames = $http.get(stopsApiUrl).then(function(res) {
      var stopData = res.data.body;
      var stops = {};
      stopData.forEach(function(stop) {
        stops[stop.shortName] = stop.name;
      });
      return stops;
    });
    return stopNames;
  }
});
