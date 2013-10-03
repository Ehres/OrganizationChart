'use strict'

angular.module('organizationChartApp', [])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl	: 'views/main.html'
        controller	: 'MainCtrl'
      .otherwise
        redirectTo	: '/'
