# coding: utf-8
require 'test_helper'

class AlbumTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
    @album = @user.albums.build(name: "Lorem ipsum",summary: "my fisrst",coverimg: "img.jpg")
  end
    
  

  test "should be valid" do
    assert @album.valid?
  end

  test "user id should be present" do
    @album.user_id = nil
    assert_not @album.valid?
  end

  test "name should be present" do
    @album.name = " "
    assert_not @album.valid?
  end

  test "name should be at most 50 characters" do
    @album.name = "a"* 51
    assert_not @album.valid?
  end

  test "order should be album4 first" do
    assert_equal albums(:album4), Album.first
  end
  
end
