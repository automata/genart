sum = (array) ->
  array.reduce (t, s) -> t + s

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

  mutate: ->
    for i in [0...@dna.length]
      @dna[i] += 1

  crossover: (other) ->
    cutPoint = Math.floor @dna.length / 2
    dad = @dna.slice 0, cutPoint
    mom = other.dna.slice cutPoint
    new Individual
      dna: dad.concat mom

  score: ->
    @fitness = sum @dna

exports.Individual = Individual
