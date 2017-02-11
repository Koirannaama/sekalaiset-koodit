
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
  this.currentStop = "Sammonkatu 47";

  var stopsApiUrl = "http://data.itsfactory.fi/journeys/api/1/stop-points";
  this.stopNamePromise = $http.get(stopsApiUrl).then(function(res) {
    var stopData = res.data.body;
    var stops = {};
    stopData.forEach(function(stop) {
      stops[stop.shortName] = stop.name;
    });
    return stops;
  });
});

app.service("lineStopLists", function($http) {
  var linesUrl = "http://data.itsfactory.fi/journeys/api/1/lines";

  this.lineStopListsPromise = $http.get(linesUrl).then(function(res) {
    var lineStops = {};
    var lines = res.data.body;

    lines.forEach(function(line) {
      var lineName = line.name;
      var description = line.description;
      getStopListsForLine(lineName).then(function(lineStopLists) {
        lineStops[lineName] = { stopLists:lineStopLists, description:description };
      });
    });
    return lineStops;
  });

  function getStopListsForLine(line) {
    var journeyUrl = "http://data.itsfactory.fi/journeys/api/1/journeys?lineId=" + line;
    var lineStopListsPromise = $http.get(journeyUrl).then(function(res) {
      var journeys = res.data.body;
      var dividedJourneys = journeys.reduce(divideJourneysByDirection, {});
      return getStopLists(dividedJourneys);

      function divideJourneysByDirection(js, j) {
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

      function getStopLists(journeysByDirection) {
        function getStopsForLongestJourney(journeys) {
          var longestJourney = journeys.reduce(getLongestJourney);
          return getStopsFromJourney(longestJourney);
        }

        var stopLists = Object.keys(journeysByDirection).map(function(directionId) {
          return getStopsForLongestJourney(journeysByDirection[directionId]);
        });
        return stopLists;
      }


    });
    return lineStopListsPromise;
  }
});

app.service("arrivalTimes", function($http) {
  this.getArrivalTimes = getArrivalTimesForStop;

  function getArrivalTimesForStop(stopCode) {
    var arrivalApiUrl = "http://data.itsfactory.fi/journeys/api/1/stop-monitoring?stops=";
    var arrivalTimesPromise = $http.get(arrivalApiUrl + stopCode)
    .then(function(res) {
      var arrivalData = res.data.body[stopCode];
      var arrivalTimes = getArrivals(arrivalData);
      return arrivalTimes;
    });
    return arrivalTimesPromise;

    function getTimeUntil(date) {
      var d = Date.parse(date);
      var diff = d - Date.now();
      return Math.floor(diff / (1000*60));
    }

    function createArrivalObject(arrival) {
      var line = arrival.lineRef;
      var time = arrival.call.expectedArrivalTime;
      return { line:line, time:getTimeUntil(time) };
    }

    function hasNotAlreadyDeparted(arrival) {
      return arrival.time >= 0;
    }

    function parseArrivalData(arrivalData) {
      var arrivals = arrivalData
        .filter(function(arrival) {
          return !arrival.call.vehicleAtStop;
        })
        .map(function(arrival) {
          return createArrivalObject(arrival);
        })
        .sort(function(a1, a2) {
          return a1.time - a2.time;
        })
        .filter(function(arrival) {
          return hasNotAlreadyDeparted(arrival);
        });
      return arrivals;
    }

    function getArrivals(arrivalData) {
      if (arrivalData === undefined) {
        return [];
      }
      else {
        return parseArrivalData(arrivalData);
      }
    }
  }
});
