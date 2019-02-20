require 'spec_helper'

describe 'BinaryGoalSeekTest' do
  before do
    @equality = Proc.new { |x| x }
  end

  it 'test_start' do
    expect(
      GoalSeeker.seek(
        start: BigDecimal.new('-10'),
        finish:BigDecimal.new('10'),
        goal: BigDecimal.new('-10.00'),
        epsilon: 0.001,
        max_cycles: 100000,
        function: @equality,
        seeker_type: :binary
      )
    ).to be_within(0.001).of -10
  end

  it 'test_finish' do
    expect(
      GoalSeeker.seek(
        start: BigDecimal.new('-10'),
        finish:BigDecimal.new('10'),
        goal: BigDecimal.new('10.00'),
        epsilon: 0.001,
        max_cycles: 100000,
        function: @equality,
        seeker_type: :binary
      )
    ).to be_within(0.001).of 10
  end

  it 'test_first_step' do
    expect(
      GoalSeeker.seek(
        start: BigDecimal.new('0'),
        finish:BigDecimal.new('10'),
        goal: BigDecimal.new('5.00'),
        epsilon: 0.001,
        max_cycles: 100000,
        function: @equality,
        seeker_type: :binary
      )
    ).to be_within(0.001).of 5
  end

  it 'test_second_step' do
    expect(
      GoalSeeker.seek(
        start:BigDecimal.new('0'),
        finish:BigDecimal.new('10'),
        goal: BigDecimal.new('7.50'),
        epsilon: 0.001,
        max_cycles: 100000,
        function: @equality,
        seeker_type: :binary
      )
    ).to be_within(0.001).of 7.5
  end

  it 'test_third_step' do
    expect(
      GoalSeeker.seek(
        start: BigDecimal.new('0'),
        finish:BigDecimal.new('10'),
        goal: BigDecimal.new('6.25'),
        epsilon: 0.001,
        max_cycles: 100000,
        function: @equality,
        seeker_type: :binary
      )
    ).to be_within(0.001).of 6.25
  end

  it 'test_nth_step' do
    expect(
      GoalSeeker.seek(
        start: BigDecimal.new('0'),
        finish:BigDecimal.new('10'),
        goal: BigDecimal.new('7'),
        epsilon: 0.001,
        max_cycles: 100000,
        function: @equality,
        seeker_type: :binary
      )
    ).to be_within(0.001).of 7
  end

  it 'test_compound_interest_rate' do
    f = Proc.new do |x|
      2*x - 25
    end
    expect(
      GoalSeeker.seek(
        start: BigDecimal.new('-1000000000000'),
        finish:BigDecimal.new('200000000000'),
        goal: BigDecimal.new('0.00'),
        epsilon: 0.001,
        max_cycles: 100000,
        function: f,
        seeker_type: :binary
      )
    ).to be_within(0.001).of 12.5
  end
end
