chai = require 'chai' unless chai
Individual = require('../src/Individual').Individual

sum = (array) ->
  array.reduce (t, s) -> t + s

describe 'Individual', ->
  describe 'when instantiated with a dna', ->
    ind = new Individual
      dna: ['a', 'b', 'c', 'd']
    it 'should create an individual with proper dna', (done) ->
      chai.expect(ind.dna).to.be.eql ['a', 'b', 'c', 'd']
      done()

  describe 'when instantiated with a size', ->
    ind = new Individual
      size: 5
    it 'should create an individual with proper dna', (done) ->
      chai.expect(ind.dna.length).to.be.equal 5
      done()

  describe 'when mutated', ->
    ind = new Individual
      size: 5
    dnaBefore = ind.dna.slice 0
    ind.mutate()
    dnaAfter = ind.dna.slice 0
    it 'should mutate its dna', (done) ->
      chai.expect(dnaBefore).to.be.not.eql dnaAfter
      done()

  describe 'when crossed over with other individual', ->
    mom = new Individual
      size: 7
    dad = new Individual
      size: 7
    son = mom.crossover dad
    it 'should generate a valid son', (done) ->
      chai.expect(son.dna.length).to.be.equal mom.dna.length
      chai.expect(son.dna.length).to.be.equal dad.dna.length
      cutPoint = Math.floor mom.dna.length / 2
      firstHalf = son.dna.slice 0, cutPoint
      chai.expect(firstHalf).to.be.eql mom.dna.slice 0, cutPoint
      secondHalf = son.dna.slice cutPoint
      chai.expect(secondHalf).to.be.eql dad.dna.slice cutPoint
      done()

  describe 'when scored', ->
    ind = new Individual
      size: 5
    ind.score()
    it 'should update its fitness', (done) ->
      fitness = sum ind.dna
      chai.expect(ind.fitness).to.be.equal fitness
      done()
