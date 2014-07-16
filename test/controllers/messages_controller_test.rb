require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  setup do

    ######### Users accounts ##########
    @user1 = users(:one)
    @user2 = users(:two)
    @user3 = users(:three)
    ######### Send http token authorization ########
    request.env['HTTP_AUTHORIZATION'] = "Token token=\"#{@user1.auth_token}\""
  end

  test "should return messages" do
    get :index, :format => :json, :conversation_id => 1
    @notes = JSON.parse(@response.body)

    # Expected message number 1
    assert @user2.id,       @notes["result"]["messages"][0]["sender"]["id"];
    assert @user2.username, @notes["result"]["messages"][0]["sender"]["username"];
    assert_equal true,      @notes["result"]["messages"][0]["sender"].has_key?("avatar")
    assert_equal true,      @notes["result"]["messages"][0]["sender"].has_key?("avatar_thumb")
    assert_equal "How are you ?", @notes["result"]["messages"][0]["content"]

    # Expected message number 2
    assert @user2.id,       @notes["result"]["messages"][1]["sender"]["id"];
    assert @user2.username, @notes["result"]["messages"][1]["sender"]["username"];
    assert_equal true,      @notes["result"]["messages"][1]["sender"].has_key?("avatar")
    assert_equal true,      @notes["result"]["messages"][1]["sender"].has_key?("avatar_thumb")
    assert_equal "What's up ?", @notes["result"]["messages"][1]["content"]

    # Expected message number 3
    assert @user1.id,       @notes["result"]["messages"][2]["sender"]["id"];
    assert @user1.username, @notes["result"]["messages"][2]["sender"]["username"];
    assert_equal true,      @notes["result"]["messages"][2]["sender"].has_key?("avatar")
    assert_equal true,      @notes["result"]["messages"][2]["sender"].has_key?("avatar_thumb")
    assert_equal "Hello !", @notes["result"]["messages"][2]["content"]
  end

  test "don't belong to conversation" do
    get :index, :format => :json, :conversation_id => 2
    @notes = JSON.parse(@response.body)
    assert "You don't belong to this conversation", @notes["result"]["error"]
  end

  test "without conversation_id" do
    get :index, :format => :json
    @notes = JSON.parse(@response.body)
    assert_equal "Please send the conversation_id parameter", @notes["result"]["error"]
  end

  test "non existing conversation_id" do
    get :index, :format => :json, :conversation_id => 4
    @notes = JSON.parse(@response.body)
    assert_equal "You don't belong to this conversation", @notes["result"]["error"]
  end


  test "message to yourself" do
    get :create, :format => :json, :message => {:recipient_id => @user1.id, :sender_id => @user1.id}
    @notes = JSON.parse(@response.body)
    assert_equal "You can't send a message to yourself.", @notes["result"]["error"]
  end

  test "without the content" do
    get :create, :format => :json, :message => {:recipient_id => @user2.id}
    @notes = JSON.parse(@response.body)
    assert_equal ["Please specify the content"], @notes["result"]["error"]["content"]
  end

  test "should create a message" do
    get :create, :format => :json, :message => {:recipient_id => @user2.id, :content => "Peace"}
    @notes = JSON.parse(@response.body)
    assert_equal "Peace",         @notes["result"]["message"]["content"]
    assert_equal @user1.id,       @notes["result"]["message"]["sender"]["id"]
    assert_equal @user1.username, @notes["result"]["message"]["sender"]["username"]
    assert_equal true,            @notes["result"]["message"]["sender"].has_key?("avatar")
    assert_equal true,            @notes["result"]["message"]["sender"].has_key?("avatar_thumb")
    assert_equal 1,               Conversation.exists?(:creator_id => @user1.id, :recipient_id => @user2.id)
  end

  test "when my allow_messages = false" do
    request.env['HTTP_AUTHORIZATION'] = "Token token=\"#{@user3.auth_token}\""
    get :create, :format => :json, :message => {:recipient_id => @user2.id, :content => "Peace"}

    @notes = JSON.parse(@response.body)
    assert_equal "Messages are not allowed", @notes["result"]["error"]
  end

  test "when recipient allow_messages = false" do
    request.env['HTTP_AUTHORIZATION'] = "Token token=\"#{@user2.auth_token}\""
    get :create, :format => :json, :message => {:recipient_id => @user3.id, :content => "Peace"}

    @notes = JSON.parse(@response.body)
    assert_equal "Messages are not allowed", @notes["result"]["error"]

  end

end
