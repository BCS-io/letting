require 'active_support'

STDOUT.sync = true

namespace :db do
  #
  # Restores
  #  - loads a database from a dump file
  #  - file created by backup gem and put into project root
  #
  desc 'Loads a database from dump file'
  task restore: [:environment, :drop, :create] do
    include Logging

    Dir.chdir(import_path) do
      logger.info "Restore: #{import_path.join(tar_file)}"
      copy_to_temp
      unpackage_dump
      restore_from_dump
      logger.info 'Complete.'
    end
  end

  private

  def import_path
    Rails.root
  end

  def copy_to_temp
    FileUtils.cp(Rails.root.join(tar_file), Rails.root.join('tmp'))
  end

  def unpackage_dump
    Dir.chdir('tmp') do
      system "tar -xvf #{tar_file} --strip=2"
      system "gzip -df #{dump_file}.gz"
      system "rm #{tar_file}"
    end
  end

  def tar_file
    "#{Rails.application.class.parent_name.underscore}.tar"
  end

  def dump_file
    'PostgreSQL.sql'
  end

  def restore_from_dump
    Dir.chdir('tmp') do
      logger.info "Tmp restore: #{Dir.pwd}/#{dump_file}"

      success = system 'pg_restore  --no-owner ' \
               "--username=#{database_config['username']} " \
               "-d #{database_config['database']} #{dump_file} " \
               '2>&1 '

      system "rm  #{dump_file}"
      logger.info(success ? 'Success' : 'Fail')
    end
  end

  def database_config
    Rails.configuration.database_configuration[Rails.env]
  end
end
