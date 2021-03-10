# Trucates all the tables - except schema_migrations
# Note: db:reset mirrors much of the calls but also db:seed which I didn't want.
# https://gist.github.com/nithinbekal/3423153

$stdout.sync = true

namespace :db do
  desc 'Truncates all the database tables'
  task truncate_all: :environment do
    ActiveRecord::Base.connection
                      .tables
                      .reject { |t| t == 'schema_migrations' }
                      .each do |table|
      ActiveRecord::Base
        .connection.execute("TRUNCATE TABLE #{table} RESTART IDENTITY;")
    end
  end
end
