require 'test_helper'

class PlaceMessagesControllerTest < ActionController::TestCase
  setup do
    @place_message = place_messages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:place_messages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create place_message" do
    assert_difference('PlaceMessage.count') do
      post :create, place_message: {  }
    end

    assert_redirected_to place_message_path(assigns(:place_message))
  end

  test "should show place_message" do
    get :show, id: @place_message
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @place_message
    assert_response :success
  end

  test "should update place_message" do
    patch :update, id: @place_message, place_message: {  }
    assert_redirected_to place_message_path(assigns(:place_message))
  end

  test "should destroy place_message" do
    assert_difference('PlaceMessage.count', -1) do
      delete :destroy, id: @place_message
    end

    assert_redirected_to place_messages_path
  end
end
