require 'active_support'

STDOUT.sync = true

namespace :db do
  #
  # Restores
  #  - loads a database from a dump file
  #  - file created by backup gem and put into projects's 'tmp/'
  #
  desc 'Loads a database from dump file'
  task restore: :environment do
    include Logging

    Dir.chdir(import_path) do
      logger.info "Current Directory: #{import_path}"
      unpackage_dump
      restore_from_dump
      cleaning_dump
      logger.info 'Complete.'
    end
  end

  private

  def import_path
    Rails.root.join 'tmp/'
  end

  def unpackage_dump
    system "tar -xvf #{tar_file} --strip=2"
    system "gzip -df #{dump_file}.gz"
  end

  def tar_file
    "#{Rails.application.class.parent_name.underscore}.tar"
  end

  def restore_from_dump
    logger.info "Restoring from: #{dump_file}"
    system 'pg_restore' \
             '--host localhost ' \
             "--username=#{database_config['username']} " \
             " -d #{database_config['database']} #{dump_file}"
  end

  def database_config
    Rails.configuration.database_configuration[Rails.env]
  end

  def cleaning_dump
    system "rm  #{dump_file}"
  end

  def dump_file
    'PostgreSQL.sql'
  end
end
