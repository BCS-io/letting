require 'active_support'

namespace :db do
  #
  # Restores
  #  - loads a database from a dump file
  #  - file created by backup gem and put into projects's 'tmp/'
  #
  desc 'Loads a database from dump file'
  task restore: :environment do
    application = Rails.application.class.parent_name.underscore
    import_path = Rails.root.join 'tmp/'
    sql_file = 'PostgreSQL.sql'

    # Unpack and ignore first two directory levels
    system "cd #{import_path} && tar -xvf #{application}.tar  --strip=2"

    # unzip
    system "gzip -df #{import_path}#{sql_file}.gz"

    # Import
    database_config = Rails.configuration.database_configuration[Rails.env]
    system "psql --username=#{database_config['username']} " \
      "-no-password #{database_config['database']} < #{import_path}/#{sql_file}"

    system "rm  #{import_path}#{sql_file}"
  end
end
