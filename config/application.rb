require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module CityGrids
  class Application < Rails::Application
    config.autoload_paths += Dir[Rails.root.join(*%w(lib *))]

    config.time_zone = 'Paris'

    I18n.config.enforce_available_locales = true
    config.i18n.available_locales = %i(fr)
    config.i18n.default_locale = :fr
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]

    config.assets.paths << Rails.root.join('vendor', 'assets', 'fonts')

    config.generators do |g|
      g.test_framework :rspec, fixture: false
    end

    config.sass.preferred_syntax = :sass
  end
end
