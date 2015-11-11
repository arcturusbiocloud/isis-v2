ENV['RAILS_ENV'] ||= 'test'

# SimpleCov
require 'simplecov'
SimpleCov.start 'rails'

# CarrierWave
CarrierWave.root = 'test/fixtures/project_uploader'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/mini_test'

class ActiveSupport::TestCase
  fixtures :users
  fixtures :projects
  fixtures :experiments

  def admin_environment
    @user = users(:one)
    begin
      sign_in @user
    rescue
      nil
    end
  end

  def email_body(email)
    email.text_part.body.to_s.chomp
  end
end
