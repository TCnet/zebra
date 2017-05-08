require 'test_helper'

class ClearsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get clears_new_url
    assert_response :success
  end

end
