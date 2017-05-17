require 'test_helper'
class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title, "BBS only for nbtcnet friends"
    assert_equal full_title("Help"), "Help | BBS only for nbtcnet friends"
  end
end
