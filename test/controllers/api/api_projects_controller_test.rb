require 'test_helper'

class ApiProjectsControllerTest < ActionController::TestCase
  tests API::ProjectsController

  setup do
    @user = users(:one)
    @project = projects(:one)
  end

  test "should update project to status running" do
    patch :update, access_token: Rails.application.secrets.access_token, id: @project, status: 1, format: :json
    assert_response :success
    assert(project = assigns(:project), 'Cannot find @project')
    assert_equal('running', project.status)
  end

  test "should update project to status completed" do
    patch :update, access_token: Rails.application.secrets.access_token, id: @project, status: 2, format: :json
    assert_response :success
    assert(project = assigns(:project), 'Cannot find @project')
    assert_equal('completed', project.status)
  end

  test "should not update project with invalid access token" do
    patch :update, access_token: 'invalid', id: @project, status: 2, format: :json
    assert_response :unauthorized
  end
end
