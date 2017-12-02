# TODO This is very naive, there are some ways to improve convergence.
class GeneticSeeker
  def initialize(start, goal, step, max_cycles, function)
    @start = start
    @goal = goal
    @step = step
    @max_cycles = max_cycles
    @function = function
    @end = max_cycles*step
    @cycle = 0
  end

  def calculate
    generation = 100.times.map {|_| @start + @end * Random.rand}

    while @cycle < @max_cycles
      generation_score = calculate_score generation
      alpha_keys = generation_score.keys.sort[0..9]
      alpha_values = alpha_keys.map{|k| generation_score[k]}
      return generation_score[alpha_keys.first] if alpha_keys.first == 0
      generation = create_new_generation alpha_values
      @cycle += 1
    end
  end

  def calculate_score generation
    generation_score = {}
    generation.each do |candidate|
      value = @function.call candidate
      score = (@goal - value).abs
      generation_score[score] = candidate
    end
    generation_score
  end

  def create_new_generation alpha_values
    new_generation = mate_generation alpha_values
    # I'm always mutating someone, but you can make it probabilistc as well
    mutant_index = (new_generation.size * Random.rand).to_i
    # it's a very agressive mutation, but I'm not in the mood of messing with
    # complext float binaries now.
    new_generation[mutant_index] = @start + @end * Random.rand
    new_generation
  end

  def mate_generation alpha_values
    new_generation = []
    alpha_values.each do |alpha|
      alpha_values.each do |beta|
        # My mating is just the avarage but you can go crazy with your bytes
        # if you want to. I like simple stuff
        new_generation << (alpha + beta) / 2
      end
    end
    new_generation
  end

  def mutate generation
    # I'm always mutating someone, but you can make it probabilistc as well
    mutant_index = (generation.size * Random.rand).to_i
    # it's a very agressive mutation, but I'm not in the mood of messing with
    # complext float binaries now.
    generation[mutant_index] = - generation[mutant_index]
  end
end
