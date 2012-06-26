# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)

ActiveRecord::IdentityMap.enabled = false
require "rails/test_help"

ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_url_options[:host] = "test.com"

Rails.backtrace_cleaner.remove_silencers!

# Configure capybara for integration testing
require "capybara/rails"
Capybara.default_driver   = :selenium
Capybara.default_selector = :css

FileUtils.rm(Dir[File.expand_path("../dummy/db/test.sqlite3", __FILE__)])
FileUtils.rm(Dir[File.expand_path("../dummy/db/migrate/*.tolk.rb", __FILE__)])
FileUtils.rm(Dir[File.expand_path("../dummy/db/tolk.sqlite3", __FILE__)])

# Setup the tolk database
Dummy::Application.load_tasks
Rake::Task["tolk:create_database"].invoke

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

class ActionController::IntegrationTest
  include Tolk::Fixtures
end

class ActiveSupport::TestCase
  include Tolk::Fixtures
  Tolk::Config.reset
end

