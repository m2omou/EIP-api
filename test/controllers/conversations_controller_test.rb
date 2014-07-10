require 'test_helper'

class ConversationsControllerTest < ActionController::TestCase
  setup do
    ######### User account ##########
    @user1 = users(:one)
    ######### Send http token authorization ########
    request.env['HTTP_AUTHORIZATION'] = "Token token=\"#{@user1.auth_token}\""
  end

  test "should delete conversation's message" do
    get :destroy, :format => :json, :id => 1
    assert_equal Message.where(:conversation_id => 1).count, 0
  end

end
