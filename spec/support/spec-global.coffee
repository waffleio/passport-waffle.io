chai = require 'chai'
chai.use require 'sinon-chai'
chai.use require 'chai-as-promised'
chai.use require 'chai-things'
GLOBAL.should = chai.should()
