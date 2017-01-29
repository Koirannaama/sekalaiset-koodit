
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
  var stopsApiUrl = "http://data.itsfactory.fi/journeys/api/1/stop-points";
  this.stopNamePromise = $http.get(stopsApiUrl).then(function(res) {
    var stopData = res.data.body;
    var stops = {};
    stopData.forEach(function(stop) {
      stops[stop.shortName] = stop.name;
    });
    return stops;
  });

  this.currentStop = "Sammonkatu 47";
});

app.service("routes", function($http) {
  var linesUrl = "http://data.itsfactory.fi/journeys/api/1/lines";

  this.lineStopListsPromise = $http.get(linesUrl).then(function(res) {
    var lineStops = {};
    var lines = res.data.body;

    lines.forEach(function(line) {
      var lineName = line.name;
      getStopListsForLine(lineName).then(function(lineStopLists) {
        lineStops[lineName] = lineStopLists;
      });
    });
    return lineStops;
  });

  function getStopListsForLine(line) {
    var journeyUrl = "http://data.itsfactory.fi/journeys/api/1/journeys?lineId=" + line;
    var lineStopListsPromise = $http.get(journeyUrl).then(function(res) {
      function getJourneyByDirection(js, j) {
        var dir = j.directionId;
        if (dir in js) {
          js[dir].push(j);
        }
        else {
          js[dir] = [j];
        }
        return js;
      }

      function getLongestJourney(j1, j2) {
        if (j1.calls.length >= j2.calls.length) {
          return j1;
        }
        else {
          return j2;
        }
      }

      function getStopsFromJourney(j) {
        var stops = j.calls.map(function(stop) {
          return { name: stop.stopPoint.name, code:stop.stopPoint.shortName };
        });
        return stops;
      }

      function getStopList(journeys) {
        if (journeys === undefined) {
          return [];
        }
        var longestJourney = journeys.reduce(getLongestJourney);
        return getStopsFromJourney(longestJourney);
      }

      var journeys = res.data.body;
      var dividedJourneys = journeys.reduce(getJourneyByDirection, {});

      var journeyToStops = getStopList(dividedJourneys["0"]);
      var journeyFroStops = getStopList(dividedJourneys["1"]);
      return {route1:journeyToStops, route2:journeyFroStops};
    });
    return lineStopListsPromise;
  }
});
