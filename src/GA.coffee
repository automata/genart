Individual = require('./Individual').Individual

cmp = (a, b) -> if a > b then -1 else if a < b then 1 else 0

Array::sortBy = (key, options) ->
  @sort (a, b) ->
    [av, bv] = [a[key], b[key]]
    [av, bv] = [av.toLowerCase(), bv.toLowerCase()] if options?.lower
    cmp av, bv

class GA
  population: []
  populationSize: 10
  maxGeneration: 100
  crossoverRate: 0.2
  mutationRate: 0.2
  eliteRate: 0.2
  generation: 0
  newPopulation: []

  constructor: (params) ->
    return unless params
    if params.populationSize
      @populationSize = params.populationSize
    if params.maxGeneration
      @maxGeneration = params.maxGeneration
    if params.crossoverRate
      @crossoverRate = params.crossoverRate
    if params.mutationRate
      @mutationRate = params.mutationRate
    @population = []
    @newPopulation = []
    numElite = @populationSize * @eliteRate
    numCrossover = @populationSize * @crossoverRate
    numMutation = @populationSize * @mutationRate
    @intervalElite = [0...numElite]
    @intervalCrossover = [numElite...numElite+numCrossover]
    @intervalMutation = [numElite+numCrossover...numElite+numCrossover+numMutation]
    @intervalRandomization = [numElite+numCrossover+numMutation...@populationSize]

  run: ->
    @generation = 0
    @initializePopulation()
    for generation in [0...@maxGeneration]
      @step()
      @generation += 1

  step: ->
    @elitization()
    @crossover()
    @mutation()
    @randomization()
    @scoring()
    @selection()

  initializePopulation: ->
    for i in [0...@populationSize]
      @population.push new Individual
        size: 10
      @newPopulation.push null

  elitization: ->
    for i in @intervalElite
      @newPopulation[i] = @population[i].copy()

  crossover: ->
    for i in @intervalCrossover
      momIdx = Math.floor Math.random() * @population.length
      dadIdx = Math.floor Math.random() * @population.length
      mom = @population[momIdx]
      dad = @population[dadIdx]
      son = mom.crossover dad
      @newPopulation[i] = son

  mutation: ->
    for i in @intervalMutation
      idx = Math.floor Math.random() * @population.length
      @population[idx].mutate()
      @newPopulation[i] = @population[idx].copy()

  randomization: ->
    for i in @intervalRandomization
      @newPopulation[i] = new Individual
        size: 10

  scoring: ->
    for i in [0...@population.length]
      @population[i].score()

  selection: ->
    @population.sortBy 'fitness'
    return

exports.GA = GA
