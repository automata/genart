'use strict'

glob = require 'glob'

DIST_TARGET = 'dist'

EXPOSED_COMPONENTS = [
  path: './ui/components/**/*.coffee', expose: 'components'
]

testServerHost = 'http://localhost:9001'
testServerPath = '/'

getAliases = (target='dist') ->
  aliases = []

  for config in EXPOSED_COMPONENTS
    files = glob.sync config.path
    for filePath in files
      newPath = filePath.replace(/\.*\/ui\/|\.*\/lib\//, '')
      newPath = newPath.replace(/\.coffee/g, '')
      aliases.push "--require #{filePath}:#{newPath}"

  if target is 'dist'
    aliases.push '--require react/addons'

  return aliases.join(' ')

module.exports = ->
  grunt = @
  # Project configuration
  @initConfig
    pkg: @file.readJSON 'package.json'

    browserify:
      dist:
        files:
          'dist/genart.js': ['src/main.coffee']
        options:
          browserifyOptions:
            extensions: ['.coffee']
            fullPaths: false
            standalone: 'genart'

    # CoffeeScript compilation of tests
    coffee:
      spec:
        options:
          bare: true
        expand: true
        cwd: 'specs'
        src: ['**.coffee']
        dest: 'specs'
        ext: '.js'
      src:
        options:
          bare: true
        expand: true
        cwd: 'src'
        src: ['**.coffee']
        dest: 'src'
        ext: '.js'

    # Automated recompilation and testing when developing
    watch:
      files: ['specs/*.coffee', 'src/*.coffee']
      tasks: ['test']

    # BDD tests on Node.js
    mochaTest:
      nodejs:
        src: ['spec/*.coffee']
        options:
          reporter: 'spec'

    # Coding standards
    coffeelint:
      components: [
        'Gruntfile.coffee'
        'specs/*.coffee'
        'src/*.coffee'
        'ui/**/*.coffee'
      ]
      options:
        max_line_length:
          level: 'ignore'

    exec:
      buildDist: "mkdir -p #{DIST_TARGET} && node_modules/.bin/browserify
        -t [ coffee-reactify --coffeeout ]
        #{getAliases('dist')}
        --extension='.coffee'
        --outfile #{DIST_TARGET}/app.js"

  @loadNpmTasks 'grunt-coffeelint-cjsx'
  @loadNpmTasks 'grunt-exec'
  @loadNpmTasks 'grunt-contrib-coffee'
  @loadNpmTasks 'grunt-contrib-watch'
  @loadNpmTasks 'grunt-coffeelint'
  @loadNpmTasks 'grunt-browserify'
  @loadNpmTasks 'grunt-mocha-test'

  @registerTask 'dev', (target='all') =>
    @task.run [
      'exec:buildDist'
    ]

  @registerTask 'build', ['coffee', 'browserify']
  @registerTask 'test', 'Run automated tests', (target = 'all') =>
    @task.run 'coffeelint'
    @task.run 'coffee'
    @task.run 'mochaTest'
  @registerTask 'default', ['test']
