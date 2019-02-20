require 'brute_force_seeker'
require 'binary_search_seeker'
require 'genetic_seeker'

class GoalSeeker
  FIXNUM_MAX = (2 ** (0.size * 8 - 2) - 1)
  FIXNUM_MIN = -(2 ** (0.size * 8 - 2))
  SEEKERS = {
    brute_force: BruteForceSeeker,
    binary: BinarySearchSeeker,
    genetic: GeneticSeeker,
  }.freeze

  DEFAULTS = {
    step:1,
    max_cycles:FIXNUM_MAX,
    epsilon: 0,
    seeker_type: :binary
  }.freeze

  def self.seek(**args)
    DEFAULTS.each {|k, v| args[k] = v if args[k].nil?}
    raise ArgumentError, "Unknown seeker type '#{args[:seeker_type]}' - only #{SEEKERS.keys} available" unless SEEKERS.key? args[:seeker_type]
    seeker = SEEKERS[args[:seeker_type]].new args
    seeker.calculate
  end
end
