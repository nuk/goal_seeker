require 'brute_force_seeker'
require 'binary_search_seeker'
require 'genetic_seeker'

class GoalSeeker
  FIXNUM_MAX = (2**(0.size * 8 -2) -1)
  FIXNUM_MIN = -(2**(0.size * 8 -2))
  SEEKERS = {
    brute_force: BruteForceSeeker,
    binary: BinarySearchSeeker,
    genetic: GeneticSeeker,
  }.freeze

  def self.seek start:, goal:, step:1, max_cycles:FIXNUM_MAX, function:, seeker_type: :binary
    raise ArgumentError, "Unknown seeker type '#{seeker_type}' - only #{SEEKERS.keys} available" unless SEEKERS.key? seeker_type
    seeker = SEEKERS[seeker_type].new start, goal, step, max_cycles, function
    seeker.calculate
  end
end
