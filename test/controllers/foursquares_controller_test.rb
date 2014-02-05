require 'test_helper'

class FoursquaresControllerTest < ActionController::TestCase
  setup do
    @foursquare = foursquares(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:foursquares)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create foursquare" do
    assert_difference('Foursquare.count') do
      post :create, foursquare: {  }
    end

    assert_redirected_to foursquare_path(assigns(:foursquare))
  end

  test "should show foursquare" do
    get :show, id: @foursquare
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @foursquare
    assert_response :success
  end

  test "should update foursquare" do
    patch :update, id: @foursquare, foursquare: {  }
    assert_redirected_to foursquare_path(assigns(:foursquare))
  end

  test "should destroy foursquare" do
    assert_difference('Foursquare.count', -1) do
      delete :destroy, id: @foursquare
    end

    assert_redirected_to foursquares_path
  end
end
