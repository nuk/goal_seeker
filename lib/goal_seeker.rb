class GoalSeeker
  FIXNUM_MAX = (2**(0.size * 8 -2) -1)
  FIXNUM_MIN = -(2**(0.size * 8 -2))

  def self.seek start:, goal:, step:1, max_cycles:FIXNUM_MAX, function:
    # seeker = BruteForceSeeker.new start, goal, step, max_cycles, function
    seeker = BinarySearchSeeker.new start, goal, step, max_cycles, function
    seeker.calculate
  end

end

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
    @param.round(2)
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
