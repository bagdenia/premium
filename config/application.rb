require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# dry-rb
require 'dry/matcher'
require 'dry/matcher/result_matcher'
require 'dry-monads'
require 'dry/monads/all'
require 'dry/transaction'

module Premium
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.autoload_paths << Rails.root.join('app')
    config.autoload_paths << Rails.root.join('app/modules')
    config.autoload_paths << Rails.root.join('app/validators')
  end
end
