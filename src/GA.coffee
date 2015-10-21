Individual = require('./Individual').Individual

class GA
  population: []
  populationSize: 10
  maxGeneration: 100

  constructor: (params) ->
    return unless params
    if params.populationSize
      @populationSize = params.populationSize
    if params.maxGeneration
      @maxGeneration = params.maxGeneration

  run: ->
    @initializePopulation()
    for generation in [0...@maxGeneration]
      @step()

  step: ->
    @elitization()
    @crossover()
    @mutation()
    @scoring()

  initializePopulation: ->
    for i in [0...@populationSize]
      @population.push new Individual
        size: 10

  elitization: ->

  crossover: ->

  mutation: ->

  scoring: ->

exports.GA = GA
