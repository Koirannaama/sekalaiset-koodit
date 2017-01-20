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

app.controller("busController", function ($http, $interval, stopNames) {
    'use strict';
    var arrivals = this;
    arrivals.stops = {};

    var arrivalApiUrl = "http://data.itsfactory.fi/journeys/api/1/stop-monitoring?stops=";
    stopNames.stopNamePromise
    .then(function(stops) {
      arrivals.stops = stops;
      arrivals.getArrivalTimes();
    });

    arrivals.shadowStopName = stopNames.currentStop;
    arrivals.errorText = "";

    arrivals.submitRequest = function() {
      stopNames.currentStop = arrivals.shadowStopName;
      arrivals.getArrivalTimes();
    };

    arrivals.getArrivalTimes = function() {
      if (arrivals.stops[stopNames.currentStop] === undefined) {
        return;
      }
      var stopCode = arrivals.stops[stopNames.currentStop];

      $http.get(arrivalApiUrl + stopCode)
      .then(function(res) {
        var arrivalData = res.data.body[stopCode];
        var arrivalTimes = getArrivals(arrivalData);
        if (arrivals.length === 0) {
          arrivals.arrivalTimes = [];
          arrivals.errorText = "Ei löytynyt aikoja.";
        }
        else {
          arrivals.arrivalTimes = arrivalTimes;
          arrivals.errorText = "";
        }
      });
    };

    var interval = $interval(function() {
      arrivals.getArrivalTimes();
    }, 3000);

    arrivals.$onDestroy = function() {
      $interval.cancel(interval);
    };
  });
