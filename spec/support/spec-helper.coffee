sinon = require 'sinon'

before -> @sinon = sinon.sandbox.create()

afterEach -> @sinon.restore()
