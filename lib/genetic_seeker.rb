# TODO This is very naive, there are some ways to improve convergence.
class GeneticSeeker
  def initialize(start, goal, step, max_cycles, epsilon, _finish, function)
    @start = start
    @goal = goal
    @step = step
    @max_cycles = max_cycles
    @function = function
    @end = max_cycles*step
    @epsilon = epsilon
    @cycle = 0
  end

  def calculate
    generation = 100.times.map {|_| @start + @end * Random.rand}

    while @cycle < @max_cycles
      generation_score = calculate_score generation
      alpha_scores = generation_score.keys.sort[0..9]
      alpha_values = alpha_scores.map{|k| generation_score[k]}
      return generation_score[alpha_scores.first] if alpha_scores.first <= @epsilon
      generation = create_new_generation alpha_values
      @cycle += 1
    end
    generation_score[alpha_scores.first]
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
    # I'm always mutating the last childs, but you can make it probabilistc as well
    # it's a very agressive mutation, but it does the trick of adding variability
    # to the mix.
    5.times.each do |mutant_index|
      new_generation[-mutant_index-1] = @start + @end * Random.rand
    end
    new_generation
  end

  def mate_generation alpha_values
    new_generation = []
    alpha_values.each do |alpha|
      alpha_values.each do |beta|
        # My mating is just an average of the parents but you can go crazy
        # with your bytes if you want to.
        new_generation << (alpha + beta)/2
      end
    end
    new_generation
  end

end
