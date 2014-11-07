chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'quotes', ->
  beforeEach ->
    @robot = 
      respond: sinon.spy()
      hear: sinon.spy()

    require('../src/quotes')(@robot)

  it 'adds a quote', ->
    expect(@robot.repond).to.have.been.calledWith(/add quote #test "Test Quote" -Someone/)

  it 'retrieves a quote', ->
    expect(@robot.hear).to.have.been.calledWith(/get quote #test/)