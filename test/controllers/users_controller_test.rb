require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    ######### User account ##########
    @user1 = users(:one)
    ######### Send http token authorization ########
    request.env['HTTP_AUTHORIZATION'] = "Token token=\"#{@user1.auth_token}\""
  end

  test "should delete associated records" do
    get :destroy, :format => :json, :id => 1

    assert_equal @user1.conversations.count, 0
    assert_equal @user1.messages.count, 0
    assert_equal @user1.comments.count, 0
    assert_equal @user1.publications.count, 0
    assert_equal @user1.report_comments.count, 0
    assert_equal @user1.report_publications.count, 0
    assert_equal @user1.votes.count, 0
    assert_equal @user1.followed_places.count, 0
    assert_equal @user1.setting, nil
  end

  test "shound create a user" do
    request.env['HTTP_AUTHORIZATION'] = nil
    post :create, :format => :json, :user => {:username => "zlatan", :email => "zlatan@gmail.com", :password => "test"}
    @data = JSON.parse(@response.body)
    puts @data
    assert_equal 0, @data["responseCode"]
  end


end
