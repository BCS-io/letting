require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Letting
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.time_zone = 'London'

    config.i18n.enforce_available_locales = true

    config.eager_load_paths += Dir[Rails.root.join('app', 'models', '{**/}'),
                                   Rails.root.join('lib', '{**/}')]
    config.exceptions_app = routes

    # basic schema cannot handle SQL views - required for account_details
    config.active_record.schema_format = :sql
  end
end
