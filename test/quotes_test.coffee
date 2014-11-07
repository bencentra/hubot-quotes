chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect
assert = chai.assert

describe 'quotes', ->
  beforeEach ->
    @robot = 
      respond: sinon.spy()
      hear: sinon.spy()

    require('../src/quotes')(@robot)

  it 'registers an "add quote" command', ->
    expect(@robot.repond).to.have.been.calledWith(/add quote #test "Test Quote" -Someone/i)

  xit 'registers a "get quote" command', ->
    expect(@robot.respond).to.have.been.calledWith(/get quote #test/i)