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
