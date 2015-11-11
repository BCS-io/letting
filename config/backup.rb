# encoding: utf-8

##
# Backup Generated: schedule_gardener
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t schedule_gardener [-c <path_to_configuration_file>]
#
# For more information about Backup's components, see the documentation at:
# http://backup.github.io/backup
#
Model.new(:letting, 'Letting') do
  rails_env = ENV['RAILS_ENV'] || 'production'
  config_dir = "#{ENV['HOME']}/apps/letting_#{rails_env}/shared/config/"

  database_config_file = "#{config_dir}/database.yml"
  db_config = YAML.load_file(database_config_file)[rails_env]

  application_config_file = "#{config_dir}/secrets.yml"
  ap_config = YAML.load_file(application_config_file)[rails_env]

  ##
  # PostgreSQL [Database]
  #
  database PostgreSQL do |db|
    db.name               = db_config['database']
    db.username           = db_config['username']
    db.password           = db_config['password']
    db.host               = 'localhost'
    db.port               = 5432
    db.additional_options = ['-c']
  end

  ##
  # Store on Amazon S3
  #
  store_with S3 do |s3|
    s3.access_key_id     = ap_config['S3_ACCESS_KEY_ID']
    s3.secret_access_key = ap_config['S3_SECRET_ACCESS_KEY']
    s3.region            = ap_config['S3_REGION']
    s3.bucket            = ap_config['S3_BUCKET']
    s3.path              = rails_env
  end

  ##
  # Local (Copy) [Storage]
  #
  store_with Local do |local|
    local.path       = '~/backups/'
    local.keep       = 5
  end

  ##
  # Gzip [Compressor]
  #
  compress_with Gzip

  ##
  # Mail [Notifier]
  #
  notify_by Mail do |mail|
    mail.on_success           = false
    # mail.on_warning           = true
    mail.on_failure           = true

    mail.from                 = ap_config['EMAIL_USERNAME']
    mail.to                   = ap_config['ALERT_EMAIL']
    mail.address              = ap_config['SMTP_ADDRESS']
    mail.port                 = 587
    mail.domain               = ap_config['DOMAIN']
    mail.user_name            = ap_config['EMAIL_USERNAME']
    mail.password             = ap_config['EMAIL_PASSWORD']
    mail.authentication       = 'login'
    mail.encryption           = :starttls
  end
end
