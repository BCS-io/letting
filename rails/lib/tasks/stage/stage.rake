STDOUT.sync = true

#
# Creates the 5 files (clients, properties, address2, acc_info, acc_items)
# in the staging directory.
# These  are created by  overwriting  the legacy/ data with patch/ data
# when necessary.
# The legacy files are the csv files  created from the adams data backup.
# The new patched files are put into the staging/ directory
#
namespace :db do
  desc 'Legacy data overwritten by patch data and saved in staging.'
  task stage: :environment do |_task, _args|
    include Logging
    logger.info 'db:stage:clients'
    Rake::Task['db:stage:clients'].invoke
    logger.info 'db:stage:properties'
    Rake::Task['db:stage:properties'].invoke
    logger.info 'db:stage:address2'
    Rake::Task['db:stage:address2'].invoke
    logger.info 'db:stage:acc_info'
    Rake::Task['db:stage:acc_info'].invoke
    logger.info 'db:stage:acc_items'
    Rake::Task['db:stage:acc_items'].invoke
  end
end
