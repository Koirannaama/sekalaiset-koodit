var app = angular.module("bussiApp", ["ngRoute"]);
app.config(function($routeProvider) {
  $routeProvider
  .when("/", {
    templateUrl: "monitor.htm",
    controller: "BusController"
  });
});
