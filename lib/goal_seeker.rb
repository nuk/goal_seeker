class BruteForceSeeker
  def initialize(start, goal, step, max_cycles, function)
    @start = start
    @goal = goal
    @step = step
    @max_cycles = max_cycles
    @function = function
    @flipped = @stop = false
  end

  def calculate
    reset_calculation
    while keep_checking
      @prev_value = @value
      @param += @current_step
      @value = @function.call @param
      change_direction_if_needed
      @cycle += 1
    end
    @param.round(4)
  end

  def reset_calculation
    @param = @start
    @prev_value = @value = @function.call @param
    @cycle = 0;
    @current_step = @step
  end

  def keep_checking() @value != @goal and @cycle < @max_cycles and not @stop end

  def diff_goal(v) (v-@goal).abs end

  def change_direction_if_needed
    if diff_goal(@value) > diff_goal(@prev_value)
      @current_step = -@current_step
      @stop = true if @flipped # avoid keep on flipping forever
      @flipped = true
    end
  end
end


class BinarySearchSeeker
  def initialize(start, goal, step, max_cycles, function)
    @start = start
    @end = max_cycles*step
    @goal = goal
    @step = step
    @max_cycles = max_cycles
    @function = function
    @cycle = 0;
    define_start_and_end
  end

  def define_start_and_end
    @start_value = @function.call @start
    if @start_value > @goal
      @end = @start
      @start = @max_cycles*@step*(-1)
    end
    @start_value = @function.call @start
    @end_value = @function.call @end
  end

  def calculate
    return @start if @start_value == @goal
    return @end if @end_value == @goal
    begin
      @cycle += 1
      mid_way = (@start + @end) / 2
      mid_value = @function.call mid_way
      return mid_way if mid_value == @goal
      update_boundaries mid_way, mid_value
    end while (@start - @end).abs > @step.abs and @cycle < @max_cycles
    mid_way
  end

  def update_boundaries mid_way, mid_value
    if (@start_value - @goal).abs > (@end_value - @goal).abs
      @start = mid_way
      @start_value = mid_value
    else
      @end = mid_way
      @end_value = mid_value
    end
  end
end

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

class GoalSeeker
  FIXNUM_MAX = (2**(0.size * 8 -2) -1)
  FIXNUM_MIN = -(2**(0.size * 8 -2))
  SEEKERS = {
    brute_force: BruteForceSeeker,
    binary: BinarySearchSeeker,
    genetic: GeneticSeeker,
  }.freeze

  def self.seek start:, goal:, step:1, max_cycles:FIXNUM_MAX, function:, seeker_type: :binary
    raise ArgumentError, "Unknown seeker type '#{seeker_type}' - only #{SEEKERS.keys} available" unless SEEKERS.key? seeker_type
    seeker = SEEKERS[seeker_type].new start, goal, step, max_cycles, function
    seeker.calculate
  end
end
