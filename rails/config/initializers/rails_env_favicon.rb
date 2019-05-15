require 'rails-env-favicon'

RailsEnvFavicon.setup do |config|
  # If true then favicon will be gray on non production env
  config.make_grayscale = false
  # or if make_grayscale = false then draw badge on favicon with this options:
  config.text_color = '#ffffff'
  config.background_color = '#000'
end

# MonkeyPatch RailsEnvFavicon so that it does not modify the icon
# during a test (which breaks tests as it changes the page's title)
# https://github.com/accessd/rails-env-favicon
module RailsEnvFavicon
  def self.applicable?
    !(::Rails.env.production? || ::Rails.env.test?)
  end
end
