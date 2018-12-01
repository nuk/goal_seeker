class BinarySearchSeeker
  def initialize(**args)
    @start = args[:start]
    @end = args[:finish]
    if args[:finish].nil?
      @end = args[:step] * args[:max_cycles]
    end
    @goal = args[:goal]
    @epsilon = args[:epsilon]
    @max_cycles = args[:max_cycles]
    @function = args[:function]
    @cycle = 0;
    define_start_and_end
  end

  def define_start_and_end
    @start_value = @function.call @start
    if @start_value > @goal
      @end = @start
      @start = @max_cycles*(-1)
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
      goal_distance = (mid_value - @goal).abs
      return mid_way if goal_distance.zero?
      update_boundaries mid_way, mid_value
    end while goal_distance > @epsilon && @cycle < @max_cycles
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
