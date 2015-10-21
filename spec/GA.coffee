chai = require 'chai' unless chai
GA = require('../src/GA').GA

sum = (array) ->
  array.reduce (t, s) -> t + s

describe 'GA', ->
  describe 'when instantiated with no params', ->
    ga = new GA()
    it 'should create a GA with default params', (done) ->
      chai.expect(ga).to.be.an 'object'
      chai.expect(ga.population).to.be.eql []
      chai.expect(ga.populationSize).to.be.equal 10
      chai.expect(ga.maxGeneration).to.be.equal 100
      chai.expect(ga.crossoverRate).to.be.equal 0.2
      chai.expect(ga.mutationRate).to.be.equal 0.2
      done()
    it 'should have no generations yet', (done) ->
      chai.expect(ga.generation).to.be.equal 0
      done()

  describe 'when running it', ->
    ga = new GA
      maxGeneration: 10
      populationSize: 5
    ga.run()
    it 'should run `maxGeneration` steps', (done) ->
      chai.expect(ga.generation).to.be.equal 10
      done()
    it 'should have generated `populationSize` individuals', (done) ->
      chai.expect(ga.population.length).to.be.equal 5
      done()
