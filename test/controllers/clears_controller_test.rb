require 'test_helper'

class ClearsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get clearw_path
    assert_response :success
  end

end
