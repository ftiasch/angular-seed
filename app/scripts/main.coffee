require.config {
    paths: {
        jquery: '../components/jquery/jquery',
    }
}

require ['app', 'jquery'], (app, $) ->
    console.log app
    console.log 'Running jQuery %s', $().jquery
