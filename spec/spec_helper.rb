require 'coveralls'
Coveralls.wear!('rails')

require 'database_cleaner'
require 'zonebie'

RSpec.configure do |config|
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
  Zonebie.set_random_timezone

  config.filter_run_excluding broken: true
end
