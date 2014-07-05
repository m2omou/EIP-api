require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase
  setup do
    get :index
    @notes = JSON.parse(@response.body)
  end

  test "should get index" do
    assert_equal 0, @notes['responseCode']
  end

  test "should at least have more than 1 category" do
    assert_operator @notes.count, :>, 0
  end

  test "should all have id and name" do
    @notes["result"]["categories"].each do |item|
      assert_equal true, item.has_key?("id")
      assert_equal true, item.has_key?("name")
    end
  end

end
