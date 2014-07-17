require 'test_helper'

class FollowedPlacesControllerTest < ActionController::TestCase
  setup do
    ######### User account ##########
    @user1 = users(:one)
  end

  test "should get by token" do
    ######### Send http token authorization ########
    request.env['HTTP_AUTHORIZATION'] = "Token token=\"#{@user1.auth_token}\""
    get :index, :format => :json
    @data = JSON.parse(@response.body)
    assert_equal 2, @data["result"]["places"].count
  end

  test "should get by user_id" do
    get :index, :format => :json, :user_id => 1
    puts @response.body
    @data = JSON.parse(@response.body)
    assert_equal 2, @data["result"]["places"].count
  end

  test "should get by user_id 2" do
    get :index, :format => :json, :user_id => 42
    puts @response.body
    @data = JSON.parse(@response.body)
    assert_equal 4, @data["result"]["places"].count
  end
end
