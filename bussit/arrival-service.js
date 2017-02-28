app.service("arrivalTimes", function($http) {
  'use strict';
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
  }

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
      .filter(function hasNotArrived(arrival) {
        return !arrival.call.vehicleAtStop;
      })
      .map(createArrivalObject)
      .sort(function compareTimes(a1, a2) {
        return a1.time - a2.time;
      })
      .filter(hasNotAlreadyDeparted);
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
});
