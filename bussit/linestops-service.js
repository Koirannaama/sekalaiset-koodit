app.service("lineStopLists", function($http) {
  'use strict';
  this.lineStopListsPromise = getStopLists();

  function getStopLists() {
    var linesUrl = "http://data.itsfactory.fi/journeys/api/1/lines";

    var stopListPromise = $http.get(linesUrl).then(function(res) {
      var lineStops = {};
      var lines = res.data.body;

      lines.forEach(function(line) {
        var lineName = line.name;
        var description = line.description;
        getStopListsForLine(lineName)
        .then(function addLineStopLists(lineStopLists) {
          lineStops[lineName] = { stopLists:lineStopLists, description:description };
        });
      });
      return lineStops;
    });
    return stopListPromise;
  }

  function getStopListsForLine(line) {
    var journeyUrl = "http://data.itsfactory.fi/journeys/api/1/journeys?lineId=" + line;
    var lineStopListsPromise = $http.get(journeyUrl).then(function(res) {
      var journeys = res.data.body;
      var dividedJourneys = journeys.reduce(divideJourneysByDirection, {});
      return getStopListsFromJourneys(dividedJourneys);
    });
    return lineStopListsPromise;
  }

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
    var stops = j.calls.map(function createStopObject(stop) {
      return { name: stop.stopPoint.name, code:stop.stopPoint.shortName };
    });
    return stops;
  }

  function getStopListsFromJourneys(journeysByDirection) {
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
