require 'test_helper'

class FlowsControllerTest < ActionController::TestCase
  setup do
    @flow = ""
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:flows)
  end

end
