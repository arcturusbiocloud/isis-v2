require 'test_helper'

class ExperimentsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    admin_environment
    @experiment = experiments(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:experiments)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create experiment' do
    assert_difference('Experiment.count') do
      post :create, experiment: { name: 'Sequencing', price: 15 }
    end

    assert_redirected_to experiments_path
  end

  test 'should not create experiment without name' do
    assert_no_difference('Experiment.count') do
      post :create, experiment: { price: 15 }
    end

    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @experiment
    assert_response :success
  end

  test 'should update experiment' do
    patch :update, id: @experiment, experiment: { name: 'qPRC', price: 18 }
    assert_redirected_to experiments_path
  end

  test 'should not update experiment without name' do
    patch :update, id: @experiment, experiment: { name: '', price: 18 }
    assert_response :success
  end

  test 'should destroy experiment' do
    assert_difference('Experiment.count', -1) do
      delete :destroy, id: @experiment
    end

    assert_redirected_to experiments_path
  end
end
