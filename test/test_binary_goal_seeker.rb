require 'minitest/autorun'
require 'goal_seeker'
require 'bigdecimal'

class BinaryGoalSeekTest < Minitest::Test
  def setup
    @equality = f = Proc.new { |x| x }
  end

  def test_start
    assert_in_epsilon -10, (GoalSeeker.seek start: BigDecimal.new('-10'), finish:BigDecimal.new('10'),
      goal: BigDecimal.new('-10.00'), epsilon: 0.001,
      max_cycles: 100000, function: @equality, seeker_type: :binary), 0.001
  end

  def test_finish
    assert_in_epsilon 10, (GoalSeeker.seek start: BigDecimal.new('-10'), finish:BigDecimal.new('10'),
      goal: BigDecimal.new('10.00'), epsilon: 0.001,
      max_cycles: 100000, function: @equality, seeker_type: :binary), 0.001
  end

  def test_first_step
    assert_in_epsilon 5, (GoalSeeker.seek start: BigDecimal.new('0'), finish:BigDecimal.new('10'),
      goal: BigDecimal.new('5.00'), epsilon: 0.001,
      max_cycles: 100000, function: @equality, seeker_type: :binary), 0.001
  end

  def test_second_step
    assert_in_epsilon 7.5, (GoalSeeker.seek start: BigDecimal.new('0'), finish:BigDecimal.new('10'),
      goal: BigDecimal.new('7.50'), epsilon: 0.001,
      max_cycles: 100000, function: @equality, seeker_type: :binary), 0.001
  end

  def test_third_step
    assert_in_epsilon 6.25, (GoalSeeker.seek start: BigDecimal.new('0'), finish:BigDecimal.new('10'),
      goal: BigDecimal.new('6.25'), epsilon: 0.001,
      max_cycles: 100000, function: @equality, seeker_type: :binary), 0.001
  end

  def test_nth_step
    assert_in_epsilon 7, (GoalSeeker.seek start: BigDecimal.new('0'), finish:BigDecimal.new('10'),
      goal: BigDecimal.new('7'), epsilon: 0.001,
      max_cycles: 100000, function: @equality, seeker_type: :binary), 0.001
  end

  def test_compound_interest_rate
    f = Proc.new do |x|
      2*x - 25
    end

    assert_in_epsilon 12.5, (GoalSeeker.seek start: BigDecimal.new('-1000000000000'), finish:BigDecimal.new('200000000000'),
      goal: BigDecimal.new('0.00'), epsilon: 0.001,
      max_cycles: 100000, function: f, seeker_type: :binary), 0.001
  end
end
