require 'test_helper'

class AlbumsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    
    @album = albums(:album1)
    
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Album.count' do
      post albums_path, params:{ album:{ name:"my album",summary: "mm"}}
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Album.count' do
      delete album_path(@album)
    end
  end

  test "should redirect destroy for wrong album" do
    log_in_as(users(:michael))
    album = albums(:album3)
    assert_no_difference 'Album.count' do
      delete album_path(album)
    end
  end

  
  
end
