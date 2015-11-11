require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  include ActiveJob::TestHelper
  include Devise::TestHelpers

  setup do
    admin_environment
    @project = projects(:one)
    @file = fixture_file_upload('/project_uploader/pithovirus.gb')
    @experiment = experiments(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create project' do
    assert_difference('Project.count') do
      post :create, project: { name: 'Pithovirus',
                               gen_bank: @file,
                               experiment_ids: [@experiment.id] }
    end

    assert(project = assigns(:project), 'Cannot find @project')

    assert_redirected_to username_project_path(@user.username, project)
  end

  test 'should not create project without name' do
    assert_no_difference('Project.count') do
      post :create, project: { gen_bank: @file }
    end

    assert_response :success
  end

  test 'should not create project without an experiment' do
    assert_no_difference('Project.count') do
      post :create, project: { name: 'Pithovirus', gen_bank: @file }
    end

    assert_response :success
  end

  test 'should show project' do
    get :show, id: @project
    assert_response :success
  end

  test 'should show project for admins' do
    get :show, id: 3
    assert_response :success
  end

  test 'should not show project - not found' do
    get :show, id: 0
    assert_response :not_found
  end

  test 'should not show project - not accessable for non admins' do
    sign_in users(:two)

    get :show, id: 2
    assert_response :not_found
  end

  test 'should get edit' do
    get :edit, id: @project
    assert_response :success
  end

  test 'should update project' do
    patch :update, id: @project, project: { is_open_source: false }
    assert_redirected_to project_path(assigns(:project))
  end

  test 'should destroy project' do
    assert_difference('Project.count', -1) do
      delete :destroy, id: @project
    end

    assert_redirected_to projects_path
  end
end
