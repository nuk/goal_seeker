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
    @last_attempt = nil
  end

  def define_start_and_end
    @start_value = @function.call @start
    @end_value = @function.call @end
  end

  def calculate
    return @start if @start_value == @goal
    return @end if @end_value == @goal
    begin
      @cycle += 1
      
      mid_way = (@start + @end) / 2
      factor = 1/@epsilon
      mid_way = (mid_way * factor).floor / factor

      return mid_way if @last_attempt == mid_way
      @last_attempt = mid_way

      mid_value = @function.call mid_way
      goal_distance = (mid_value - @goal).abs

      # This is necessary since BigDecimal has a Negative Zero
      # Which is different from a Positive Zero
      # This keeps the results consistent no matter which
      # type of number you're using
      return mid_way if goal_distance.zero?
      update_boundaries mid_way, mid_value
    end while goal_distance > @epsilon && @cycle < @max_cycles
    mid_way
  end

  def update_boundaries mid_way, mid_value
    if within @end_value, mid_value, @goal
      @start = mid_way
      @start_value = mid_value
    else
      @end = mid_way
      @end_value = mid_value
    end
  end

  def within a, b, value
     (a <= value && value <= b) ||
      (b <= value && value <= a)
  end
end
