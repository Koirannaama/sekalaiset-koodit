
var app = angular.module("bussiApp", ["ngRoute"]);
app.config(function($routeProvider) {
  'use strict';
  $routeProvider
  .when("/", {
    templateUrl: "monitor.htm",
    controller: "busController"
  })
  .when("/stops", {
    templateUrl: "stop-info.htm",
    controller: "stopInfoController"
  });
});

app.service("stopNames", function($http) {
  var stopsApiUrl = "http://data.itsfactory.fi/journeys/api/1/stop-points";
  this.stopNamePromise = $http.get(stopsApiUrl).then(function(res) {
    var stopData = res.data.body;
    var stops = {};
    stopData.forEach(function(stop) {
      stops[stop.name] = stop.shortName;
    });
    return stops;
  });

  this.currentStop = "Sammonkatu 47";
});

app.service("routes", function($http) {
  this.routes = {"1":{ route1: ["Kissa", "Koira", "Hiiri", "Marsu"],
                       route2: ["Marsu", "Hiiri", "Koira", "Kissa"] },
                 "2":{ route1: ["Lihasula", "Ranta-Perkiö"],
                       route2: ["Ranta-Perkiö", "Lihasula"]} };
});
