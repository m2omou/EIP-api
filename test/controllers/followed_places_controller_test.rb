require 'test_helper'

class FollowedPlacesControllerTest < ActionController::TestCase
  setup do
    @followed_place = followed_places(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:followed_places)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create followed_place" do
    assert_difference('FollowedPlace.count') do
      post :create, followed_place: { followed_place_id: @followed_place.followed_place_id, user_id: @followed_place.user_id }
    end

    assert_redirected_to followed_place_path(assigns(:followed_place))
  end

  test "should show followed_place" do
    get :show, id: @followed_place
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @followed_place
    assert_response :success
  end

  test "should update followed_place" do
    patch :update, id: @followed_place, followed_place: { followed_place_id: @followed_place.followed_place_id, user_id: @followed_place.user_id }
    assert_redirected_to followed_place_path(assigns(:followed_place))
  end

  test "should destroy followed_place" do
    assert_difference('FollowedPlace.count', -1) do
      delete :destroy, id: @followed_place
    end

    assert_redirected_to followed_places_path
  end
end
