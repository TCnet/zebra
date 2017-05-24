# coding: utf-8
require 'test_helper'

class AlbumsInterfaceTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
  end

  test "album interface" do
    log_in_as(@user)
    get albums_path
    assert_select 'aside.albums_menu'
    assert_select 'ul.nav'
    get new_album_path
    
    
  end
    
end
