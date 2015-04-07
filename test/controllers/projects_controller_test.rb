require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @user = users(:one)
    sign_in @user rescue nil
    @project = projects(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:projects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project" do
    assert_difference('Project.count') do
      post :create, project: { name: 'My project', description: 'Super cool', is_open_source: true, design: 'source-code' }
    end

    assert_redirected_to project_path(assigns(:project))
  end

  test "should not create project with empty fields" do
    assert_no_difference('Project.count') do
      post :create, project: { name: '' }
    end

    assert_match('Can&#39;t be blank', response.body)
  end

  test "should show project" do
    get :show, id: @project
    assert_response :success
  end

  test "should not show project - not found" do
    get :show, id: 0
    assert_response :not_found
  end

  test "should not show project - not accessable" do
    get :show, id: 2
    assert_response :not_found
  end

  test "should get edit" do
    get :edit, id: @project
    assert_response :success
  end

  test "should update project" do
    patch :update, id: @project, project: { name: 'Updated project', description: 'New description', is_open_source: false, design: 'source-code v2' }
    assert_redirected_to project_path(assigns(:project))
  end

  test "should not update project with empty fields" do
    patch :update, id: @project, project: { name: '' }
    assert_match('Can&#39;t be blank', response.body)
  end

  test "should destroy project" do
    assert_difference('Project.count', -1) do
      delete :destroy, id: @project
    end

    assert_redirected_to projects_path
  end
end
