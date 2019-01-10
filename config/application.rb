require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Letting
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those
    # specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.time_zone = 'London'

    config.i18n.enforce_available_locales = true

    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{**/}'),
                                 "#{config.root}/lib/**/"]
    config.exceptions_app = routes

    # basic schema cannot handle SQL views - required for account_details
    config.active_record.schema_format = :sql
  end
end
