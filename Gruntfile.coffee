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
            jade: {
                files: ['<%= yeoman.app %>/views/*.jade'],
                tasks: ['jade'],
            },
            coffee: {
                files: ['<%= yeoman.app %>/scripts/*.coffee'],
                tasks: ['coffee:dist']
            },
            coffeeTest: {
                files: ['test/spec/*.coffee'],
                tasks: ['coffee:test']
            },
            less: {
                files: ['<%= yeoman.app %>/styles/*.less'],
                tasks: ['less'],
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
        jade: {
            dist: {
                options: {
                    pretty: true,
                },
                files: [{
                    expand: true,
                    cwd: '<%= yeoman.app %>/views',
                    src: '**/*.jade',
                    dest: '.tmp/views',
                    ext: '.html',
                }]
            }
        },
        coffee: {
            dist: {
                files: [{
                    expand: true,
                    cwd: '<%= yeoman.app %>/scripts',
                    src: '**/*.coffee',
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
        less: {
            options: {
                paths: ['<%= yeoman.app %>/styles', '<%= yeoman.app %>/components'],
            },
            dist: {
                files: {
                    '.tmp/styles/main.css': '<%= yeoman.app %>/styles/main.less',
                },
            }
        },
        # not used since Uglify task does concat,
        # but still available if needed
        # concat: {
        #     dist: {}
        # },
        requirejs: {
            dist: {
                # Options: https://github.com/jrburke/r.js/blob/master/build/example.build.js
                options: {
                    # `name` and `out` is set by grunt-usemin
                    baseUrl: 'app/scripts',
                    optimize: 'none',
                    # TODO: Figure out how to make sourcemaps work with grunt-usemin
                    # https://github.com/yeoman/grunt-usemin/issues/30
                    # generateSourceMaps: true,
                    # required to support SourceMaps
                    # http://requirejs.org/docs/errors.html#sourcemapcomments
                    preserveLicenseComments: false,
                    useStrict: true,
                    wrap: true,
                    #uglify2: {} # https://github.com/mishoo/UglifyJS2
                    mainConfigFile: '.tmp/scripts/main.js'
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
                    removeComments: true,
                    #removeCommentsFromCDATA: true,
                    # https://github.com/yeoman/grunt-usemin/issues/44
                    collapseWhitespace: true,
                    collapseBooleanAttributes: true,
                    #removeAttributeQuotes: true,
                    #removeRedundantAttributes: true,
                    useShortDoctype: true,
                    #removeEmptyAttributes: true,
                    #removeOptionalTags: true
                },
                files: [{
                    expand: true,
                    cwd: '<%= yeoman.app %>',
                    src: '*.html',
                    dest: '<%= yeoman.dist %>',
                }, {
                    expand: true,
                    cwd: '.tmp/views',
                    src: '**/*.html',
                    dest: '<%= yeoman.dist %>/views',
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
                }, {
                    expand: true,
                    cwd: '.tmp/scripts',
                    dest: '<%= yeoman.dist %>/scripts',
                    src: '**/*.js',
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
            'jade',
            'coffee:dist',
            'less',
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
        #'test',
        'jade',
        'coffee',
        'less',
        #'useminPrepare',
        #'requirejs',
        'imagemin',
        'cssmin',
        'htmlmin',
        #'concat',
        #'uglify',
        'copy',
        #'usemin'
    ]

    grunt.registerTask 'default', ['build']
