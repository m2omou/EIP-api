require 'test_helper'

class PublicationsControllerTest < ActionController::TestCase
  setup do
    ######### Users accounts ##########
    @user1 = users(:one)
    @user2 = users(:two)
    @user3 = users(:three)
    ######### Send http token authorization ########
    request.env['HTTP_AUTHORIZATION'] = "Token token=\"#{@user1.auth_token}\""
  end

  test "Get by user_id" do
    get :index, :format => :json, :user_id => 42
    @data = JSON.parse(@response.body)
    assert_equal 2, @data["result"]["publications"].count
  end

  test "Get by place_id" do
    get :index, :format => :json, :place_id => "51a2445e5019c80b56934c80"
    @data = JSON.parse(@response.body)
    assert_equal 2, @data["result"]["publications"].count
  end

  test "Get by place_id & user_id" do
    get :index, :format => :json, :place_id => "51a2445e5019c80b56934c80", :user_id => 21
    @data = JSON.parse(@response.body)
    assert_equal 1, @data["result"]["publications"].count
  end

  test "Show one" do
    get :show, :format => :json, :id => 2
    @data = JSON.parse(@response.body)
    assert_equal "love this place", @data["result"]["publication"]["content"]
  end

  test "Create with close distance" do
    post :create, :format => :json, :publication => {:place_id => "51a2445e5019c80b56934c75",
                                                     :user_latitude => 48.85816464940564,
                                                     :user_longitude => 2.2944259643554683,
                                                     :content => "Moi et ma maman"}
    @data = JSON.parse(@response.body)
    assert_equal 0, @data["responseCode"]
  end

  test "Create with far distance" do
    post :create, :format => :json, :publication => {:place_id => "51a2445e5019c80b56934c75",
                                                     :user_latitude => 58.85816464940564,
                                                     :user_longitude => 2.2944259643554683,
                                                     :content => "Moi et ma maman"}
    @data = JSON.parse(@response.body)
    assert_equal 1, @data["responseCode"]
  end

end
