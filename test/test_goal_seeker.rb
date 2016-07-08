require 'minitest/autorun'
require 'goal_seeker'
require 'bigdecimal'

class GoalSeekTest < Minitest::Test
  def test_same
    assert_equal 0, (GoalSeeker.seek  :start=>0 , :goal=>0, :function=>lambda { |x| x })
  end

  def test_next_step
    assert_equal 1, (GoalSeeker.seek  start: 0 , goal: 1, function: lambda { |x| x })
    assert_equal 10, (GoalSeeker.seek  start: 0 , goal: 10, function: lambda { |x| x })
  end

  def test_param_is_not_goal
    assert_equal 5, (GoalSeeker.seek  start: 0 , goal: 10, function: lambda { |x| 2*x })
  end

  def test_stop_after_a_while
    assert 100 >= (GoalSeeker.seek  start: 0 , goal: 1000, max_cycles:100,
      function: lambda { |x| 2*x })
  end

  def test_functions_with_multiple_answers
    assert_equal 3, (GoalSeeker.seek  start: 100 , goal: 0, max_cycles:100,
      function: lambda { |x| x*x -5*x + 6 }) # answers can be 2 or 3
  end

  def test_step_in_the_oposite_direction
    assert_equal -1, (GoalSeeker.seek  start: 0 , goal: -1, max_cycles:10, function: lambda { |x| x })
  end

  def test_float
    f = Proc.new do |value|
       (value*2.06/100)/(1-((1+2.06/100)**(-95)));
    end
    assert_in_epsilon -962.24, (GoalSeeker.seek  start: 0 , goal: -23.16, step:0.01,
      max_cycles:1000*1000, function: f), 0.01
  end

  def test_float
    f = Proc.new do |value|
       (value*BigDecimal.new('2.02')/100)/(1-((1+BigDecimal.new('2.02')/100)**(-95)));
    end
    assert_in_epsilon -1152.70, (GoalSeeker.seek  start: 0 , goal: -27.38, step:0.01,
      max_cycles:1000*1000, function: f), 0.01
  end
end
