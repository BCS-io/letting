$stdout.sync = true

namespace :db do
  desc 'Sets the autoincrement for all tables'
  task set_autoincrement: :environment do
    ActiveRecord::Base.connection
                      .tables
                      .reject { |table| table == 'schema_migrations' }
                      .reject { |table| table.end_with? '_id_seq' }
                      .each do |table|
      ActiveRecord::Base
        .connection.execute("SELECT setval('#{table}_id_seq'," \
                            " (SELECT MAX(id) FROM #{table}));")
    end
  end
end
