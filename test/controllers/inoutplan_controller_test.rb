require 'test_helper'

class InoutplanControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get inoutplan_new_url
    assert_response :success
  end

  test "should get index" do
    get inoutplan_index_url
    assert_response :success
  end

end
