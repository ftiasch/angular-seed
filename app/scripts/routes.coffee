'use strict'

define ['app'], (app) ->
    app.config ['$routeProvider', ($routeProvider) ->
        $routeProvider.when '/', {
            templateUrl: 'views/main.html',
        }
    ]
