require_relative "boot"

require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'active_storage/engine'

Bundler.require(*Rails.groups)

module TestSpecification
  class Application < Rails::Application
    config.load_defaults 7.2
    config.autoload_lib(ignore: %w[assets tasks])
    config.api_only = true
  end
end
