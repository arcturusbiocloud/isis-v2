ENV['RAILS_ENV'] ||= 'test'

# SimpleCov
require 'simplecov'
SimpleCov.start 'rails'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/mini_test'

class ActiveSupport::TestCase
  fixtures :users
  fixtures :projects
end
