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
    step = @step
    prev_value = value = @function.call param
    cycle = 0;
    while value != @goal and cycle < @max_cycles
      param += step
      value = @function.call param
      # puts "#{param} : #{value}"
      if diff_goal value > diff_goal prev_value 
        step = 0-step
      end
      prev_value = value
      cycle += 1
    end
    param.round(2)
  end

  def diff_goal(v) (v-@goal).abs end


end
