Goal Seeker
==================

  This is a small lib that tries to emulate  the famous spreadsheet function that
keeps trying a bunch of values until one satisfies your conditions. Very handy to
brute force some math problems.


Usage
------------
```ruby
  GoalSeeker.seek(
    start, # First value to be tried
    goal, # Value that your stop function should reach to stop
    max_cycles, # Maximum number of iterations that you are willing to spend looking for the answer
    function, # fit function, it receives a number and produces another one that will be matched against the goal value
    seeker_type # [Optional] Defines which algorithm will be used to search for the goal value. Can be:
    # :binary (default): Will use a binary search to find the best fit
    # :brute_force: Will look sequentially for the best fit. This algorithm also receives a `step` value that defines the increment of each step, Default is set to 1.
    # :genetic: Will use a very simple genetic algorithm to solve find the best fit. There's an optional `epsilon` argument that can be used to specify how accurate you expect the result to be. Default is set to 0. [WARNING] this is a probabilistic strategy, so the timing to solve things can vary. So, use with care.
  )
```

Examples:
_____________

```ruby
  GoalSeeker.seek(
    start: 100,
    goal: 0,
    max_cycles:100,
    function: lambda { |x| x*x -5*x + 6 }
  ) # Will return 3 (the other solution to the equation is 2 =] )
```

Running tests
____________

Just go and `rake test`
