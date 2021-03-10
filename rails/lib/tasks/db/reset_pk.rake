# Each time a row is added to the database the PK is incremented
# However, with the seed/import this is not happening.
# At the end of the seed I go through all the tables and make sure the PK
# points to the next empty row!
#
$stdout.sync = true

namespace :db do
  desc 'Fix for automatic pk sequence getting out of step with your data rows.'
  task reset_pk: :environment do
    ActiveRecord::Base.connection
                      .tables
                      .reject { |t| t == 'schema_migrations' }
                      .each do |table|
      ActiveRecord::Base.connection.reset_pk_sequence!(table)
    end
  end
end
