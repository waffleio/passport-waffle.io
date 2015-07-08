strategy = require '../src'

describe 'passport-waffle.io', ->
  it 'exports Strategy constructor directly from package', ->
    strategy.should.be.a 'function'

  it 'export Strategy constructor', ->
    strategy.Strategy.should.be.a 'function'
    strategy.Strategy.should.equal strategy
