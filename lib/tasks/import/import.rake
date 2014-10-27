# Drop, Create, Migrate, Test Prepare and then populate the development
# Note: db:reset mirrors much of the calls but also db:seed which I didn't want.
# https://gist.github.com/nithinbekal/3423153

require 'optparse'

STDOUT.sync = true

namespace :db do

  desc "Imports lettings data from csv's generated by previous system."
  task :import, [:range, :test] => :environment do |_task, args|
    include Logging

    options = parse_options args

    human_ref_range = Rangify.from_str(options[:range]).to_s

    # Stripped out for now but when in parallel with live system. nope
    logger.info 'db:truncate_all'
    Rake::Task['db:truncate_all'].execute
    logger.info 'Cleanse legacy code for staging'
    Rake::Task['db:stage'].invoke
    logger.info 'db:import basic system files'
    Rake::Task['db:import:users'].invoke(options[:test])
    Rake::Task['db:import:due_ons'].invoke
    Rake::Task['db:import:cycle'].invoke
    Rake::Task['db:import:charged_ins'].invoke
    # Rake::Task['db:import:cycle_charged_ins'].invoke
    Rake::Task['db:import:template_address'].invoke
    Rake::Task['db:import:template_notice'].invoke
    Rake::Task['db:import:template'].invoke

    logger.info 'db:import::clients'
    Rake::Task['db:import:clients'].execute
    logger.info 'db:import::properties'
    Rake::Task['db:import:properties'].invoke(human_ref_range)
    puts
    logger.info 'db:import::agents'
    Rake::Task['db:import:agents'].invoke(human_ref_range)
    puts
    logger.info 'db:import::charges'
    Rake::Task['db:import:charges'].invoke(human_ref_range)
    puts
    logger.info 'db:import::accounts'
    Rake::Task['db:import:accounts'].invoke(human_ref_range)
    puts
    logger.info 'db:import::update_charges'
    Rake::Task['db:import:update_charges'].invoke
    exit 0
  end

  # Do add to this method until refactored!
  # rubocop: disable  Metrics/LineLength
  # rubocop: disable  Metrics/MethodLength
  def parse_options args
    options = {}
    OptionParser.new(args) do |opts|
      opts.banner = 'Usage: rake db:import -- [options]'

      options[:range] = '1-9000'
      opts.on('-r', '--range {range}', 'Range of properties to import default: 1..9000.', String) do |range|
        options[:range] = range
      end

      options[:test] = false
      opts.on('-t', '--test', "Make users with password 'password'", String) do
        options[:test] = true
      end

      opts.on('-h', '--help', 'Display this screen') do
        puts opts
        exit
      end
    end.parse!
    options
  end
end
