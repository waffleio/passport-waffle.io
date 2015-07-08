PassportWaffleStrategy = require '../src'
Q = require 'q'

describe 'strategy', ->
  it 'is named "waffle"', ->
    strategy = new PassportWaffleStrategy
      clientID: 'client-id'
      clientSecret: 'client-secret'
    , (accessToken, refreshToken, profile, done) ->

    should.exist strategy.name, 'strategy should be named "waffle"'
    strategy.name.should.equal 'waffle'

  it 'defaults user agent', ->
    strategy = new PassportWaffleStrategy
      clientID: 'client-id'
      clientSecret: 'client-secret'
    , (accessToken, refreshToken, profile, done) ->

    strategy._oauth2._customHeaders['User-Agent'].should.equal 'passport-waffle.io'

  it 'customizes config options', ->
    strategy = new PassportWaffleStrategy
      clientID: 'client-id'
      clientSecret: 'client-secret'
      userAgent: 'example.net'
      baseURL: 'http://waffle.example.com'
      baseApiURL: 'http://api.waffle.example.com'
    , (accessToken, refreshToken, profile, done) ->

    strategy._oauth2._customHeaders['User-Agent'].should.equal 'example.net'
    strategy._oauth2._authorizeUrl.should.equal 'http://waffle.example.com/login/oauth/authorize'
    strategy._oauth2._accessTokenUrl.should.equal 'http://waffle.example.com/login/oauth/token'
    strategy._userProfileURL.should.equal 'http://api.waffle.example.com/user'

  it 'requires clientID', ->
    constructor = ->
      new PassportWaffleStrategy
        clientSecret: 'client-secret'
        userAgent: 'example.net'
      , (accessToken, refreshToken, profile, done) ->

    constructor.should.throw 'OAuth2Strategy requires a clientID option'

  it 'requires clientSecret', ->
    constructor = ->
      new PassportWaffleStrategy
        clientID: 'client-id'
        userAgent: 'example.net'
      , (accessToken, refreshToken, profile, done) ->

    constructor.should.throw 'OAuth2Strategy requires a clientSecret option'

  describe '#userProfile', ->
    beforeEach ->
      @strategy = new PassportWaffleStrategy
        clientID: 'client-id'
        clientSecret: 'client-secret'
      , (accessToken, refreshToken, profile, done) ->

      {@waffleUser} = require './fixtures'
      @accessToken = 'token'
      @sinon.stub @strategy._oauth2, 'get'
        .withArgs 'https://api.waffle.io/user', @accessToken
        .yields null, JSON.stringify(@waffleUser)

    it 'parses profile', ->
      Q.ninvoke @strategy, 'userProfile', @accessToken
      .then (profile) =>
        profile.id.should.equal @waffleUser._id
        profile.username.should.equal @waffleUser.github.login
        profile.displayName.should.equal @waffleUser.github.name
        profile.avatar.should.equal @waffleUser.github.avatar_url
        profile.emails.length.should.equal 1
        profile.emails.should.include.a.thing.that.deep.equals value: @waffleUser.github.email

    it 'sets raw property', ->
      Q.ninvoke @strategy, 'userProfile', @accessToken
      .then (profile) =>
        should.exist profile._raw, 'profile should have raw property'
        profile._raw.should.equal JSON.stringify(@waffleUser)

    it 'sets json property', ->
      Q.ninvoke @strategy, 'userProfile', @accessToken
      .then (profile) =>
        should.exist profile._json, 'profile should have raw property'
        profile._json.should.eql @waffleUser

    it 'errors if fetching user profile errors', ->
      @strategy._oauth2.get
        .withArgs 'https://api.waffle.io/user', @accessToken
        .yields 'error fetching user'

      Q.ninvoke @strategy, 'userProfile', @accessToken
      .should.be.rejectedWith 'Failed to fetch user profile'
