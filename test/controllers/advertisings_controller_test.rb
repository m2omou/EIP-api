require 'test_helper'

class AdvertisingsControllerTest < ActionController::TestCase
  setup do
    @advertising = advertisings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:advertisings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create advertising" do
    assert_difference('Advertising.count') do
      post :create, advertising: { id: @advertising.id }
    end

    assert_redirected_to advertising_path(assigns(:advertising))
  end

  test "should show advertising" do
    get :show, id: @advertising
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @advertising
    assert_response :success
  end

  test "should update advertising" do
    patch :update, id: @advertising, advertising: { id: @advertising.id }
    assert_redirected_to advertising_path(assigns(:advertising))
  end

  test "should destroy advertising" do
    assert_difference('Advertising.count', -1) do
      delete :destroy, id: @advertising
    end

    assert_redirected_to advertisings_path
  end
end
