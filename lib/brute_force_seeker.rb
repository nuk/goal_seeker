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
