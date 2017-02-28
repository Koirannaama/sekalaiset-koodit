app.controller("monitorController", function ($interval, stopNames, arrivalTimes) {
    'use strict';
    var monitor = this;
    monitor.stops = {};
    monitor.shadowStopName = stopNames.currentStop;
    monitor.errorText = "";
    monitor.timeMax = 20;
    monitor.submitRequest = submitArrivalRequest;

    stopNames.stopNamePromise
    .then(function(stopNames) {
      function getDisplayName(name, code) {
        return name + " (" + code + ")";
      }

      for (var stop in stopNames) {
        var displayName = getDisplayName(stopNames[stop], stop);
        monitor.stops[displayName] = stop;
      }
      getArrivalTimes();
    });

    function submitArrivalRequest() {
      stopNames.currentStop = monitor.shadowStopName;
      getArrivalTimes();
    }

    function getArrivalTimes() {
      if (monitor.stops[stopNames.currentStop] === undefined) {
        return;
      }
      var stopCode = monitor.stops[stopNames.currentStop];

      arrivalTimes.getArrivalTimes(stopCode)
      .then(function(arrivals) {
        if (arrivals.length === 0) {
          monitor.arrivalTimes = [];
          monitor.errorText = "Ei löytynyt aikoja.";
        }
        else {
          monitor.arrivalTimes = arrivals;
          monitor.errorText = "";
        }
      });
    }

    var interval = $interval(function() {
      getArrivalTimes();
    }, 30000);

    monitor.$onDestroy = function() {
      $interval.cancel(interval);
    };
  });
