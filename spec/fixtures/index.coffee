fs = require 'fs'
_ = require 'lodash'
S = require 'string'
Proxy = require 'node-proxy'

module.exports = Proxy.create
  get: (receiver, name) ->
    dashed = S(name).dasherize().s
    _.cloneDeep require("./#{dashed}")
