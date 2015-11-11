require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    admin_environment
  end

  test 'should get index' do
    get :index
    assert_response :success
  end
end
