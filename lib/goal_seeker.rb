FIXNUM_MAX = (2**(0.size * 8 -2) -1)
FIXNUM_MIN = -(2**(0.size * 8 -2))

class GoalSeeker
  def self.seek start:, goal:, step:1, max_cycles:FIXNUM_MAX, function:
    seeker = GoalSeeker.new start, goal, step, max_cycles, function
    seeker.calculate
  end

  def initialize(start, goal, step, max_cycles, function)
    @start = start
    @goal = goal
    @step = step
    @max_cycles = max_cycles
    @function = function
  end

  def calculate
    param = @start
    prev_value = value = @function.call param
    cycle = 0;
    @current_step = @step
    while value != @goal and cycle < @max_cycles
      param += @current_step
      value = @function.call param
      change_direction_if_needed value, prev_value
      prev_value = value
      cycle += 1
    end
    param.round(2)
  end

  def diff_goal(v) (v-@goal).abs end
  def change_direction_if_needed value, prev_value
    if diff_goal(value) > diff_goal(prev_value)
      @current_step = 0-@current_step
    end
  end


end
