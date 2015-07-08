Profile = require '../src/profile'

describe 'profile', ->

  describe '#parse', ->
    it 'parses profile', ->
      {waffleUser} = require './fixtures'
      profile = Profile.parse waffleUser

      profile.id.should.equal waffleUser._id
      profile.username.should.equal waffleUser.github.login
      profile.displayName.should.equal waffleUser.github.name
      profile.avatar.should.equal waffleUser.github.avatar_url
      profile.emails.length.should.equal 1
      profile.emails.should.include.a.thing.that.deep.equals value: waffleUser.github.email

    it 'parses profile with null email', ->
      {waffleUser} = require './fixtures'
      delete waffleUser.github.email
      profile = Profile.parse waffleUser

      profile.id.should.equal waffleUser._id
      profile.username.should.equal waffleUser.github.login
      profile.displayName.should.equal waffleUser.github.name
      profile.avatar.should.equal waffleUser.github.avatar_url
      should.not.exist profile.emails
