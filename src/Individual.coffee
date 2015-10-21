class Individual
  dna: []
  fitness: 0.0

  constructor: (params) ->
    if params.size
      @dna = []
      for i in [0...params.size]
        @dna.push Math.floor Math.random() * 10
    else if params.dna
      @dna = params.dna
    if params.fitness
      @fitness = params.fitness

  mutate: ->
    for i in [0...@dna.length]
      @dna[i] = (@dna[i] + 1) % 10

  crossover: (other) ->
    cutPoint = Math.floor @dna.length / 2
    dad = @dna.slice 0, cutPoint
    mom = other.dna.slice cutPoint
    new Individual
      dna: dad.concat mom

  score: ->
    @fitness = @dna.reduce (t, s) -> t + s

  copy: ->
    new Individual
      dna: @dna.slice 0
      fitness: @fitness

exports.Individual = Individual
