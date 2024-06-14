require "test_helper"

class DocumentsControllerTest < ActionDispatch::IntegrationTest
  test "should get compare" do
    get documents_compare_url
    assert_response :success
  end
end
