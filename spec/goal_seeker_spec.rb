require 'spec_helper'

describe 'GoalSeekTest' do

  it 'test_same' do
    expect(
      GoalSeeker.seek(
        :start=>0,
        :goal=>0,
        :function=>lambda { |x| x },
        seeker_type: :brute_force
      )
    ).to eq 0
  end

  it 'test_next_step' do
    expect(
      GoalSeeker.seek(
        start: 0,
        goal: 1,
        function: lambda { |x| x },
        seeker_type: :brute_force
      )
    ).to eq 1
    expect(
      GoalSeeker.seek(
        start: 0,
        goal: 10,
        function: lambda { |x| x },
        seeker_type: :brute_force
      )
    ).to eq 10
  end

  it 'test_param_is_not_goal' do
    expect(
      GoalSeeker.seek(
        start: 0,
        goal: 10,
        function: lambda { |x| 2*x },
        seeker_type: :brute_force
      )
    ).to eq 5
  end

  it 'test_stop_after_a_while' do
    expect(
      GoalSeeker.seek(
        start: 0,
        goal: 1000,
        max_cycles:100,
        function: lambda { |x| 2*x },
        seeker_type: :brute_force
      )
    ).to eq 100
  end

  it 'test_functions_with_multiple_answers' do
    expect(
      GoalSeeker.seek(
        start: 100,
        goal: 0,
        max_cycles:100,
        function: lambda { |x| (x * x - 5 * x + 6) }, # answers can be 2 or 3
        seeker_type: :brute_force
      )
    ).to eq 3
  end

  it 'test_step_in_the_oposite_direction' do
    expect(
      GoalSeeker.seek(
        start: 0,
        goal: -1,
        max_cycles: 10,
        function: lambda { |x| x },
        seeker_type: :brute_force
      )
    ).to eq -1
  end

  # # it 'test_float' do
  # #   f = Proc.new do |value|
  # #      (value*2.06/100)/(1-((1+2.06/100)**(-95)));
  # #   end
  # #   assert_in_epsilon -962.24, (GoalSeeker.seek  start: 0 , goal: -23.16, step:0.01,
  # #     max_cycles:1000, function: f, seeker_type: :brute_force), 0.01
  # # end

  # # it 'test_big_decimal' do
  # #   f = Proc.new do |value|
  # #      (value*BigDecimal.new('2.02')/100)/(1-((1+BigDecimal.new('2.02')/100)**(-95)));
  # #   end
  # #   assert_in_epsilon -1152.70, (GoalSeeker.seek  start: 0 , goal: -27.38, step:0.01,
  # #     max_cycles:1000, function: f, seeker_type: :brute_force), 0.01
  # # end

  it 'test_compound_interest_rate' do
    f = Proc.new do |interest|
      total = 0
      (1..57).each do |t|
        total += 787.00 / ((1 + interest)**t)
      end
      total
    end

    expect(
      GoalSeeker.seek(
        start: BigDecimal.new('0.01000'),
        goal: BigDecimal.new('26000.00'),
        step: 0.00001,
        max_cycles: 100000,
        function: f,
        seeker_type: :brute_force
      )
    ).to be_within(0.00001).of 0.0210
  end

  it 'test_genetic_seeker' do
    epsilon = 0.0000000000001
    value = (
      GoalSeeker.seek  start: 0 , goal: 0, max_cycles: 1000_000,
      function: lambda { |x| (x * x - 5 * x + 6) }, # answers can be 2 or 3
      seeker_type: :genetic,
      epsilon: epsilon
    )
    epsilon_2 = (2 - value).abs
    epsilon_3 = (3 - value).abs
    expect(
      !(epsilon_2 <= epsilon or epsilon_3 <= epsilon )
    ).to be_falsey
      # "#{value} is not close to 2 or 3"
  end

  it 'test_raise_exception_for_unknown_seeker_type' do
    expect {
      GoalSeeker.seek(
        :start=>0,
        :goal=>0,
        :function=>lambda { |x| x },
        :seeker_type=>:unknown_seeker
      )
    }.to raise_error ArgumentError
  end
end
