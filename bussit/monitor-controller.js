app.controller("monitorController", function ($interval, stopNames, arrivalTimes, currentStop) {
    'use strict';
    var monitor = this;
    monitor.displayStopNames = {};
    monitor.stopNames = {};
    monitor.shadowStopName = undefined; //= currentStop.currentStopCode;
    monitor.errorText = "";
    monitor.timeMax = 20;
    monitor.submitRequest = submitArrivalRequest;

    stopNames.stopNamePromise
    .then(function(stopNames) {
      monitor.stopNames = stopNames;
      if (currentStop.currentStopCode !== undefined) {
        var name = stopNames[currentStop.currentStopCode];
        var code = currentStop.currentStopCode;
        monitor.shadowStopName = getDisplayName(name, code);
      }

      for (var stop in stopNames) {
        var displayName = getDisplayName(stopNames[stop], stop);
        monitor.displayStopNames[displayName] = stop;
      }

      getArrivalTimes();

      function getDisplayName(name, code) {
        return name + " (" + code + ")";
      }
    });

    function submitArrivalRequest() {
      if (monitor.shadowStopName !== undefined) {
        currentStop.currentStopCode = monitor.displayStopNames[monitor.shadowStopName];
        getArrivalTimes();
      }
    }

    function getArrivalTimes() {
      if (currentStop.currentStopCode === undefined) {
        return;
      }
      var stopCode = currentStop.currentStopCode;

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
