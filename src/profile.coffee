_ = require 'lodash'

###
 * Parse profile.
 *
 * @param {Object|String} json
 * @return {Object}
 * @api private
###
exports.parse = (json) ->
  if _.isString json
    json = JSON.parse json

  profile =
    id: json._id
    displayName: json.github.name
    username: json.github.login
    avatar: json.github.avatar_url

  if json.github.email?
    profile.emails = [{ value: json.github.email }]

  return profile
