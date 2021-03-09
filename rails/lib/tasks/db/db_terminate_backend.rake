# http://stackoverflow.com/questions/5108876/kill-a-postgresql-session-connection
# rake db:terminate RAILS_ENV=test
namespace :db do
  desc "Fix 'database is being accessed by other users'"
  task terminate: :environment do
    ActiveRecord::Base.connection.execute <<-SQL
      SELECT
        pg_terminate_backend(pid)
      FROM
        pg_stat_activity
      WHERE
        -- don't kill my own connection!
        pid <> pg_backend_pid()
        -- don't kill the connections to other databases
        AND datname = '#{ActiveRecord::Base.connection.current_database}';
    SQL
  end
end

Rake::Task['db:drop'].enhance ['db:terminate']
