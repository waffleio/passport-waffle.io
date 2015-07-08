util = require 'util'
Profile = require './profile'
OAuth2Strategy = require 'passport-oauth2'
InternalOAuthError = OAuth2Strategy.InternalOAuthError

###
 * `Strategy` constructor.
 *
 * The Waffle.io authentication strategy authenticates requests by delegating to
 * Waffle.io using the OAuth 2.0 protocol.
 *
 * Applications must supply a `verify` callback which accepts an `accessToken`,
 * `refreshToken` and service-specific `profile`, and then calls the `done`
 * callback supplying a `user`, which should be set to `false` if the
 * credentials are not valid.  If an exception occured, `err` should be set.
 *
 * Options:
 *   - `baseURL`       base url for Waffle.io. defaults to 'https://waffle.io'
 *   - `baseApiURL`    base url for the Waffle.io API. defaults to 'https://api.waffle.io'
 *   - `clientID`      your Waffle.io application's Client ID
 *   - `clientSecret`  your Waffle.io application's Client Secret
 *   - `callbackURL`   URL to which Waffle.io will redirect the user after granting authorization
 *   - `scope`         array of permission scopes to request. only '*' for now
 *   — `userAgent`     All API requests MUST include a valid User Agent string.
 *                     e.g: domain name of your application.
 *
 * Examples:
 *
 *     WaffleStrategy = require('passport-waffle');
 *
 *     passport.use(new WaffleStrategy({
 *         clientID: '123-456-789',
 *         clientSecret: 'shhh-its-a-secret'
 *         callbackURL: 'https://www.example.net/auth/waffle/callback',
 *         userAgent: 'myapp.com'
 *       },
 *       function(accessToken, refreshToken, profile, done) {
 *         User.findOrCreate(..., function (err, user) {
 *           done(err, user);
 *         });
 *       }
 *     ));
 *
 * @param {Object} options
 * @param {Function} verify
 * @api public
###
Strategy = (options={}, verify) ->
  options.baseURL ?= 'https://waffle.io'
  options.baseApiURL ?= 'https://api.waffle.io'
  options.authorizationURL ?= "#{options.baseURL}/login/oauth/authorize"
  options.tokenURL ?= "#{options.baseURL}/login/oauth/token"
  options.userProfileURL ?= "#{options.baseApiURL}/user"
  options.customHeaders ?= {}

  unless options.customHeaders['User-Agent']
    options.customHeaders['User-Agent'] = options.userAgent ? 'passport-waffle.io'

  OAuth2Strategy.call this, options, verify
  @name = 'waffle'
  @_userProfileURL = options.userProfileURL

###
 * Inherit from `OAuth2Strategy`.
###
util.inherits Strategy, OAuth2Strategy


###
 * Retrieve user profile from Waffle.
 *
 * This function constructs a normalized profile, with the following properties:
 *
 *   - `provider`         always set to `waffle`
 *   - `id`               the user's User ID
 *   - `username`         the user's Waffle username
 *   - `displayName`      the user's full name
 *   - `emails`           the user's email addresses
 *
 * @param {String} accessToken
 * @param {Function} done
 * @api protected
###
Strategy.prototype.userProfile = (accessToken, done) ->
  @_oauth2.get @_userProfileURL, accessToken, (err, body, res) ->
    if err?
      return done(new InternalOAuthError('Failed to fetch user profile', err))

    try
      json = JSON.parse(body)
    catch e
      return done(new Error('Failed to parse user profile'))

    profile = Profile.parse json
    profile.provider  = 'waffle'
    profile._raw = body
    profile._json = json

    done null, profile

###
 * Expose `Strategy`.
###
module.exports = Strategy;
