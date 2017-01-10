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

angular.module("bussiApp", [])
  .controller("BusController", function ($http, $interval){
    var arrivals = this;
    arrivals.arrivalApiUrl = "http://data.itsfactory.fi/journeys/api/1/stop-monitoring?stops=";
    arrivals.stopCode = "4517";
    arrivals.errorText = "";

    arrivals.getArrivalTimes = function() {
      $http.get(arrivals.arrivalApiUrl + arrivals.stopCode)
      .then(function(res) {
        var arrivalData = res.data.body[arrivals.stopCode];
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

    arrivals.getArrivalTimes();
    interval = $interval(function() {
      arrivals.getArrivalTimes();
    }, 3000);

    arrivals.$onDestroy = function() {
      $interval.cancel(interval);
    };
  });
