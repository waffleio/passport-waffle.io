'use strict'

module.exports = (grunt) ->

  grunt.initConfig
    bump:
      options:
        pushTo: 'origin'

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
            'spec/support/spec-global.coffee'
          ]
        src: [
          'spec/support/spec-helper.coffee'
          'spec/**/*spec.coffee'
        ]

  if grunt.option.flags().indexOf('--test') > -1
    grunt.config.merge
      watch:
        serverTest:
          files: '{src,spec}/**/*.coffee'
          tasks: ['test:server']

  grunt.registerTask 'test', ['mochaTest']
  grunt.registerTask 'default', ['clean', 'coffee']

  grunt.loadNpmTasks 'grunt-bump'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-contrib-watch'
