require 'test_helper'

class ReportCommentsControllerTest < ActionController::TestCase
  setup do
    @report_comment = report_comments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:report_comments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create report_comment" do
    assert_difference('ReportComment.count') do
      post :create, report_comment: { comment_id: @report_comment.comment_id, content: @report_comment.content, reason: @report_comment.reason, user_id: @report_comment.user_id }
    end

    assert_redirected_to report_comment_path(assigns(:report_comment))
  end

  test "should show report_comment" do
    get :show, id: @report_comment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @report_comment
    assert_response :success
  end

  test "should update report_comment" do
    patch :update, id: @report_comment, report_comment: { comment_id: @report_comment.comment_id, content: @report_comment.content, reason: @report_comment.reason, user_id: @report_comment.user_id }
    assert_redirected_to report_comment_path(assigns(:report_comment))
  end

  test "should destroy report_comment" do
    assert_difference('ReportComment.count', -1) do
      delete :destroy, id: @report_comment
    end

    assert_redirected_to report_comments_path
  end
end
