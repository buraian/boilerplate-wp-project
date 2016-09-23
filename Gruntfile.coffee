module.exports = (grunt) ->
  'use strict'

  require('load-grunt-tasks') grunt
  require('time-grunt') grunt

  modernizrConfig = require('./node_modules/modernizr/lib/config-all.json')
  modernizrTests = modernizrConfig['feature-detects']

  # Project configuration
  grunt.initConfig

    # Metadata
    pkg: grunt.file.readJSON 'package.json'
    name: 'boilerplate-wp-theme-default'
    banner:
      """
      /*! <%= name %> - v<%= pkg.version %>
       * Copyright (c) <%= grunt.template.today('yyyy') %> <%= pkg.author.name %> <<%= pkg.author.url %>> */


      """

    # Paths
    src: 'src'
    build: 'build'

    themes:
      default: 'themes/<%= name %>'
      # junior: 'themes/<%= name %>-junior'
    # plugins:
    #   custom: 'plugins/custom'
    #   another: 'plugins/another'

    # Target-specific file lists and/or options go here.
    clean:
      themes: [
        '<%= build %>/<%= themes.default %>/**/*'
        # '<%= build %>/<%= themes.junior %>/**/*'
      ]
      # plugins: [
      #   '<%= build %>/<%= plugins.custom %>/**/*'
      #   '<%= build %>/<%= plugins.another %>/**/*'
      # ]

    concat:
      options:
        banner: '<%= banner %>'
      dist:
        src: [
          '<%= build %>/<%= themes.default %>/assets/js/modernizr-output.js'
          'node_modules/foundation-sites/js/foundation/foundation.js'
          # 'node_modules/foundation-sites/js/foundation/foundation.abide.js'
          # 'node_modules/foundation-sites/js/foundation/foundation.accordion.js'
          'node_modules/foundation-sites/js/foundation/foundation.alert.js'
          # 'node_modules/foundation-sites/js/foundation/foundation.clearing.js'
          # 'node_modules/foundation-sites/js/foundation/foundation.dropdown.js'
          # 'node_modules/foundation-sites/js/foundation/foundation.equalizer.js'
          # 'node_modules/foundation-sites/js/foundation/foundation.interchange.js'
          # 'node_modules/foundation-sites/js/foundation/foundation.joyride.js'
          # 'node_modules/foundation-sites/js/foundation/foundation.magellan.js'
          # 'node_modules/foundation-sites/js/foundation/foundation.offcanvas.js'
          # 'node_modules/foundation-sites/js/foundation/foundation.orbit.js'
          # 'node_modules/foundation-sites/js/foundation/foundation.reveal.js'
          # 'node_modules/foundation-sites/js/foundation/foundation.slider.js'
          # 'node_modules/foundation-sites/js/foundation/foundation.tab.js'
          # 'node_modules/foundation-sites/js/foundation/foundation.tooltip.js'
          # 'node_modules/foundation-sites/js/foundation/foundation.topbar.js'
          'node_modules/picturefill/dist/picturefill.js'
          '<%= src %>/<%= themes.default %>/common/scripts/main.js'
        ]
        dest: '<%= build %>/<%= themes.default %>/assets/js/main.js'
        nonull: true

    copy:
      favicon:
        files: [
          expand: true
          cwd: '<%= src %>/<%= themes.default %>'
          src: ['favicon.ico']
          dest: '<%= build %>/<%= themes.default %>/'
        ]
      fonts:
        files: [
          expand: true
          cwd: '<%= src %>/<%= themes.default %>/fonts'
          src: ['**/*.{woff,woff2,tff,eot,svg,otf}']
          dest: '<%= build %>/<%= themes.default %>/assets/fonts/'
          flatten: true
        ,
          expand: true
          cwd: 'node_modules/font-awesome/fonts'
          src: ['**/*.{woff,woff2,tff,eot,svg,otf}']
          dest: '<%= build %>/<%= themes.default %>/assets/fonts/'
        ]
      scripts:
        src: [
          'node_modules/html5shiv/dist/html5shiv.js'
        ]
        dest: '<%= build %>/<%= themes.default %>/assets/js/html5shiv.js'
      templates:
        files: [
          expand: true
          cwd: '<%= src %>'
          src: ['**/*.{php,inc}']
          dest: '<%= build %>/<%= themes.default %>/'
          flatten: true
        ]
      videos:
        files: [
          expand: true
          cwd: '<%= src %>/<%= themes.default %>'
          src: ['**/*.{mp4,ogv,webm}']
          dest: '<%= build %>/<%= themes.default %>/assets/videos/'
          flatten: true
        ]

    cssmin:
      dist:
        options:
          keepSpecialComments: false
          shorthandCompacting: false
        files: [
          expand: true
          cwd: '<%= build %>/<%= themes.default %>/assets/css'
          src: ['*.css', '!*.min.css']
          dest: '<%= build %>/<%= themes.default %>/assets/css'
          ext: '.min.css'
        ]

    # This create a style.css file required by WordPress
    'file-creator':
      options:
        openFlags: 'w+'
      files: [
        file: '<%= build %>/<%= themes.default %>/style.css'
        method: (fs, fd, done) ->
          fs.writeSync fd, grunt.template.process(
            """
            /*
            Theme Name: <%= name %>
            Author: <%= pkg.author.name %>
            Author URI: <%= pkg.author.url %>
            Description: <%= pkg.description %>
            Version: <%= pkg.version %>
            */
            """
          )
          done()
      ]

    imagemin:
      raster:
        files: [
          expand: true
          cwd: '<%= build %>/<%= themes.default %>/assets/images/'
          src: ['**/*.{gif,jpg,jpeg}']
          dest: '<%= build %>/<%= themes.default %>/assets/images/'
          flatten: true
        ]
      vector:
        options:
          svgoPlugins: [
            removeViewBox: false
          ]
        files: [
          expand: true
          cwd: '<%= src %>/<%= themes.default %>/common/images/'
          src: ['**/*.svg']
          dest: '<%= build %>/<%= themes.default %>/assets/images/'
          flatten: true
        ]

    # https://github.com/Modernizr/customizr#config-file
    modernizr:
      dist:
        customTests: []
        dest: '<%= build %>/<%= themes.default %>/assets/js/modernizr-output.js'
        devFile: false
        options: [
          'setClasses'
        ]
        parseFiles: true
        uglify: true
        tests: modernizrTests
        excludeTests: []
        crawl: false
        useBuffers: false
        files:
          src: ['/node_modules/modernizr/lib/config-all.json']
        customTests: []

    pngmin:
      compile:
        options:
          ext: '.png'
          force: true
        files: [
          expand: true
          cwd: '<%= build %>/<%= themes.default %>/assets/images/'
          src: ['**/*.png']
          dest: '<%= build %>/<%= themes.default %>/assets/images/'
          flatten: true
        ]

    postcss:
      options:
        map: true
        processors: [
          require('autoprefixer')(browsers: [
            '> 1%'
            'Chrome > 0'
            'Explorer >= 8'
            'Firefox >= 4'
            'iOS >= 6'
            'Opera >= 12'
            'Safari > 0'
          ])
        ]
      dist:
        src: '<%= build %>/<%= themes.default %>/assets/css/**/*.css'

    responsive_images:
      all:
        options:
          engine: "im" # ImageMagick
          sizes: [
            # Extra Small (< 480)
            name: 'sm'
            quality: 80
            width: 479
          ,
            # Small (< 768)
            name: 'sm'
            quality: 80
            width: 767
          ,
            # Medium (< 992)
            name: 'md'
            quality: 80
            width: 991
          ,
            # Large (< 1200)
            name: 'lg'
            quality: 80
            width: 1199
          ,
            # Extra Large (< 1920)
            name: 'xl'
            quality: 80
            width: 1919
          ,
            # Original
            rename: false
            quality: 80
            width: '100%'
          ]
        files: [
          expand: true
          cwd: '<%= src %>/<%= themes.default %>'
          src: ['**/*.{gif,jpg,jpeg,png}']
          dest: '<%= build %>/<%= themes.default %>/assets/images/'
          flatten: true
        ]

    sass:
      options:
        outFile: '<%= build %>/<%= themes.default %>/assets/css/'
        outputStyle: 'expanded'
        sourceMap: true
      dist:
        files: [
          expand: true
          cwd: '<%= src %>/<%= themes.default %>/common/styles'
          src: ['**/*.{sass,scss}']
          dest: '<%= build %>/<%= themes.default %>/assets/css/'
          ext: '.css'
          extDot: 'last'
        ]

    uglify:
      options:
        banner: '<%= banner %>'
      dist:
        src: ['<%= build %>/<%= themes.default %>/assets/js/main.js']
        dest: '<%= build %>/<%= themes.default %>/assets/js/main.min.js'

    watch:
      gruntfile:
        files: ['Gruntfile.{coffee,js}']
        tasks: ['default']

      fonts:
        files: ['<%= src %>/<%= themes.default %>/**/*.{woff,woff2,tff,eot,svg,otf}']
        tasks: ['newer:copy:fonts']
        options:
          livereload: true

      images:
        files: ['<%= src %>/<%= themes.default %>/**/*.{gif,jpg,jpeg,png,svg}']
        tasks: ['images']
        options:
          livereload: true

      scripts:
        files: ['<%= src %>/<%= themes.default %>/**/*.{coffee,js}']
        tasks: ['scripts']
        options:
          livereload: true

      styles:
        files: ['<%= src %>/<%= themes.default %>/**/*.{sass,scss}']
        tasks: ['styles']
        options:
          livereload: true

      templates:
        files: ['<%= src %>/<%= themes.default %>/**/*.{php,inc}']
        tasks: ['newer:copy:templates']
        options:
          livereload: true
          
      videos:
        files: ['<%= src %>/<%= themes.default %>/**/*.{mp4,ogv,webm}']
        tasks: ['copy:videos']
        options:
          livereload: true

  # Default task
  grunt.registerTask 'default', [
    'build'
    'watch'
  ]

  # Build task
  grunt.registerTask 'build', [
    'mkdir'
    'clean'
    'file-creator'
    'images'
    'assets'
    'templates'
    'styles'
    'scripts'
  ]

  # Assets
  grunt.registerTask 'assets', [
    'copy:favicon'
    'copy:fonts'
    'copy:videos'
  ]

  # Images
  grunt.registerTask 'images', [
    'responsive_images'
    'imagemin'
    'pngmin'
  ]

  # Make Directories
  grunt.registerTask 'mkdir', () ->
    # Each Theme
    for k,v of grunt.config('themes')
      grunt.file.mkdir "#{grunt.config('build')}/#{grunt.config('themes')[k]}"

  # Scripts
  grunt.registerTask 'scripts', [
    'modernizr'
    'concat'
    'uglify'
    'copy:scripts'
  ]

  # Styles
  grunt.registerTask 'styles', [
    'sass'
    'postcss'
    'cssmin'
  ]

  # Templates
  grunt.registerTask 'templates', [
    'copy:templates'
  ]
