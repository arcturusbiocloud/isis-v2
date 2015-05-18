require 'test_helper'

class ApiActivitiesControllerTest < ActionController::TestCase
  tests API::ActivitiesController

  setup do
    @user = users(:one)
    @project = projects(:one)
  end

  test "should create new activity with key assembling" do
    assert_difference('Activity.count', +1) do
      post :create, access_token: Rails.application.secrets.access_token, project_id: @project.id, key: 1, format: :json
    end
    assert_response :success
    assert(activity = assigns(:activity), 'Cannot find @activity')
    assert_equal('assembling', activity.key)
    assert_equal('running', activity.project.status)
  end

  test "should create new activity with key transforming" do
    assert_difference('Activity.count', +1) do
      post :create, access_token: Rails.application.secrets.access_token, project_id: @project.id, key: 2, format: :json
    end
    assert_response :success
    assert(activity = assigns(:activity), 'Cannot find @activity')
    assert_equal('transforming', activity.key)
  end

  test "should create new activity with key plating" do
    assert_difference('Activity.count', +1) do
      post :create, access_token: Rails.application.secrets.access_token, project_id: @project.id, key: 3, format: :json
    end
    assert_response :success
    assert(activity = assigns(:activity), 'Cannot find @activity')
    assert_equal('plating', activity.key)
  end

  test "should create new activity with key incubating" do
    assert_difference('Activity.count', +1) do
      post :create, access_token: Rails.application.secrets.access_token, project_id: @project.id, key: 4, format: :json
    end
    assert_response :success
    assert(activity = assigns(:activity), 'Cannot find @activity')
    assert_equal('incubating', activity.key)
  end

  test "should create new activity with key picture_taken" do
    file = fixture_file_upload('images/sample.png', 'image/png')

    assert_difference('Activity.count', +1) do
      post :create, access_token: Rails.application.secrets.access_token, project_id: @project.id, key: 5, content: file, format: :json
    end
    assert_response :success
    assert(activity = assigns(:activity), 'Cannot find @activity')
    assert_equal('picture_taken', activity.key)
  end

  test "should create new activity with key completed" do
    assert_difference('Activity.count', +1) do
      post :create, access_token: Rails.application.secrets.access_token, project_id: @project.id, key: 6, format: :json
    end
    assert_response :success
    assert(activity = assigns(:activity), 'Cannot find @activity')
    assert_equal('completed', activity.key)
    assert_equal('completed', activity.project.status)
  end
end
