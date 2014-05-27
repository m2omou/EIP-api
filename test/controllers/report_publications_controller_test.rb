require 'test_helper'

class ReportPublicationsControllerTest < ActionController::TestCase
  setup do
    @report_publication = report_publications(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:report_publications)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create report_publication" do
    assert_difference('ReportPublication.count') do
      post :create, report_publication: { content: @report_publication.content, publication_id: @report_publication.publication_id, reason: @report_publication.reason, user_id: @report_publication.user_id }
    end

    assert_redirected_to report_publication_path(assigns(:report_publication))
  end

  test "should show report_publication" do
    get :show, id: @report_publication
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @report_publication
    assert_response :success
  end

  test "should update report_publication" do
    patch :update, id: @report_publication, report_publication: { content: @report_publication.content, publication_id: @report_publication.publication_id, reason: @report_publication.reason, user_id: @report_publication.user_id }
    assert_redirected_to report_publication_path(assigns(:report_publication))
  end

  test "should destroy report_publication" do
    assert_difference('ReportPublication.count', -1) do
      delete :destroy, id: @report_publication
    end

    assert_redirected_to report_publications_path
  end
end
