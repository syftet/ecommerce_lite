require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module EcommerceLite
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.autoload_paths << "#{Rails.root}/lib"
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.active_record.belongs_to_required_by_default = false

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '/api/*', :headers => :any, :methods => [:get, :post, :options]
      end
    end
  end
end
