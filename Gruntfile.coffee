'use strict'

module.exports = (grunt) ->

  grunt.initConfig
    coffee:
      src:
        expand: true
        cwd: 'src/'
        src: ['**/*.coffee']
        dest: 'lib/'
        ext: '.js'

    clean: ['lib']

    watch:
      src:
        files: 'src/**/*.coffee'
        tasks: ['clean', 'coffee:src']

    mochaTest:
      test:
        options:
          reporter: 'dot'
          require: [
            'coffee-script/register'
            'spec/spec-global.coffee'
          ]
        src: ['spec/**/*.coffee']

  grunt.registerTask 'test', ['mochaTest']
  grunt.registerTask 'default', ['clean', 'coffee']

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-contrib-watch'
