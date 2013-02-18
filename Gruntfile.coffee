'use strict'

lrSnippet = require('grunt-contrib-livereload/lib/utils').livereloadSnippet
mountFolder = (connect, dir) ->
    connect.static(require('path').resolve(dir))

module.exports = (grunt) ->
    # load all grunt tasks
    require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

    # configurable paths
    yeomanConfig = {
        app: 'app',
        dist: 'dist'
    }

    grunt.initConfig {
        yeoman: yeomanConfig,
        watch: {
            coffee: {
                files: ['<%= yeoman.app %>/scripts/*.coffee'],
                tasks: ['coffee:dist']
            },
            coffeeTest: {
                files: ['test/spec/*.coffee'],
                tasks: ['coffee:test']
            },
            livereload: {
                files: [
                    '<%= yeoman.app %>/*.html',
                    '{.tmp,<%= yeoman.app %>}/styles/*.css',
                    '{.tmp,<%= yeoman.app %>}/scripts/*.js',
                    '<%= yeoman.app %>/images/*.{png,jpg,jpeg}'
                ],
                tasks: ['livereload']
            }
        },
        connect: {
            options: {
                port: 9000
            },
            livereload: {
                options: {
                    middleware: (connect) ->
                        return [
                            lrSnippet,
                            mountFolder(connect, '.tmp'),
                            mountFolder(connect, 'app')
                        ]
                }
            },
            test: {
                options: {
                    middleware: (connect) ->
                        return [
                            mountFolder(connect, '.tmp'),
                            mountFolder(connect, 'test')
                        ]
                }
            },
            dist: {
                options: {
                    middleware: (connect) ->
                        return [
                            mountFolder(connect, 'dist')
                        ]
                }
            }
        },
        open: {
            server: {
                url: 'http://localhost:<%= connect.options.port %>'
            }
        },
        clean: {
            dist: ['.tmp', '<%= yeoman.dist %>/*'],
            server: '.tmp'
        },
        jshint: {
            options: {
                jshintrc: '.jshintrc'
            },
            all: [
                'Gruntfile.js',
                '<%= yeoman.app %>/scripts/*.js',
                'test/spec/*.js'
            ]
        },
        mocha: {
            all: {
                options: {
                    run: true,
                    urls: ['http://localhost:<%= connect.options.port %>/index.html']
                }
            }
        },
        coffee: {
            dist: {
                files: [{
                    expand: true,
                    cwd: '<%= yeoman.app %>/scripts',
                    src: '*.coffee',
                    dest: '.tmp/scripts',
                    ext: '.js'
                }]
            },
            test: {
                files: [{
                    expand: true,
                    cwd: '.tmp/spec',
                    src: '*.coffee',
                    dest: 'test/spec'
                }]
            }
        },
        # not used since Uglify task does concat,
        # but still available if needed
        # concat: {
        #     dist: {}
        # },
        requirejs: {
            dist: {
                # Options: https:#github.com/jrburke/r.js/blob/master/build/example.build.js
                options: {
                    # `name` and `out` is set by grunt-usemin
                    baseUrl: 'app/scripts',
                    optimize: 'none',
                    # TODO: Figure out how to make sourcemaps work with grunt-usemin
                    # https:#github.com/yeoman/grunt-usemin/issues/30
                    #generateSourceMaps: true,
                    # required to support SourceMaps
                    # http:#requirejs.org/docs/errors.html#sourcemapcomments
                    preserveLicenseComments: false,
                    useStrict: true,
                    wrap: true,
                    #uglify2: {} # https:#github.com/mishoo/UglifyJS2
                    mainConfigFile: 'app/scripts/main.js'
                }
            }
        },
        useminPrepare: {
            html: '<%= yeoman.app %>/index.html',
            options: {
                dest: '<%= yeoman.dist %>'
            }
        },
        usemin: {
            html: ['<%= yeoman.dist %>/*.html'],
            css: ['<%= yeoman.dist %>/styles/*.css'],
            options: {
                dirs: ['<%= yeoman.dist %>']
            }
        },
        imagemin: {
            dist: {
                files: [{
                    expand: true,
                    cwd: '<%= yeoman.app %>/images',
                    src: '*.{png,jpg,jpeg}',
                    dest: '<%= yeoman.dist %>/images'
                }]
            }
        },
        cssmin: {
            dist: {
                files: {
                    '<%= yeoman.dist %>/styles/main.css': [
                        '.tmp/styles/*.css',
                        '<%= yeoman.app %>/styles/*.css'
                    ]
                }
            }
        },
        htmlmin: {
            dist: {
                options: {
                    #removeCommentsFromCDATA: true,
                    ## https:#github.com/yeoman/grunt-usemin/issues/44
                    ##collapseWhitespace: true,
                    #collapseBooleanAttributes: true,
                    #removeAttributeQuotes: true,
                    #removeRedundantAttributes: true,
                    #useShortDoctype: true,
                    #removeEmptyAttributes: true,
                    #removeOptionalTags: true
                },
                files: [{
                    expand: true,
                    cwd: '<%= yeoman.app %>',
                    src: '*.html',
                    dest: '<%= yeoman.dist %>'
                }]
            }
        },
        copy: {
            dist: {
                files: [{
                    expand: true,
                    dot: true,
                    cwd: '<%= yeoman.app %>',
                    dest: '<%= yeoman.dist %>',
                    src: [
                        '*.{ico,txt}',
                        '.htaccess'
                    ]
                }]
            }
        },
        bower: {
            rjsConfig: 'app/scripts/main.js',
            indent: '    '
        }
    }

    grunt.renameTask 'regarde', 'watch'
    # remove when mincss task is renamed
    grunt.renameTask 'mincss', 'cssmin'

    grunt.registerTask 'server', (target) ->
        if target == 'dist'
            return grunt.task.run ['open', 'connect:dist:keepalive']

        grunt.task.run [
            'clean:server',
            'coffee:dist',
            'livereload-start',
            'connect:livereload',
            'open',
            'watch'
        ]

    grunt.registerTask 'test', [
        'clean:server',
        'coffee',
        'connect:test',
        'mocha'
    ]

    grunt.registerTask 'build', [
        'clean:dist',
        'jshint',
        'test',
        'coffee',
        'useminPrepare',
        'requirejs',
        'imagemin',
        'cssmin',
        'htmlmin',
        'concat',
        'uglify',
        'copy',
        'usemin'
    ]

    grunt.registerTask 'default', ['build']