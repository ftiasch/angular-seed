require.config {
    paths: {
        require: '../components/requirejs/require',
        jquery: '../components/jquery/jquery',
        underscore: '../components/underscore/underscore',
        angular: '../components/angular/angular',
    },
    shim: {
        angular: {
            exports: 'angular',
        },
        underscore: {
            exports: '_',
        }
    }
}

require ['angular', 'app', 'controllers/controllers', 'routes'], (angular, app) ->
    angular.element(document).ready () ->
        angular.bootstrap document, ['myApp']
