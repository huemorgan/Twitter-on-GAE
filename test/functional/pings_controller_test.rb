require 'test_helper'

class PingsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ping" do
    assert_difference('Ping.count') do
      post :create, :ping => { }
    end

    assert_redirected_to ping_path(assigns(:ping))
  end

  test "should show ping" do
    get :show, :id => pings(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => pings(:one).to_param
    assert_response :success
  end

  test "should update ping" do
    put :update, :id => pings(:one).to_param, :ping => { }
    assert_redirected_to ping_path(assigns(:ping))
  end

  test "should destroy ping" do
    assert_difference('Ping.count', -1) do
      delete :destroy, :id => pings(:one).to_param
    end

    assert_redirected_to pings_path
  end
end
