require 'test_helper'

class AlbumsHelperTest < ActionView::TestCase
  def setup
    
    @album = albums(:album1)
    @photos = photos(:photo1)
    
    
  end
  
  test "code for photos" do
    code = %w{be}
    assert_equal @album.photos.count,2
    assert_equal code_for(@album.photos,"123456789$$"), code
    
  end

  test "keywords for" do
    code =%w{1 2 3 4 5 6 7 8 9 10 11}
    max = 2
    s = %w(1 2 3 4 5 6 7).in_groups(3, false) {|group| p group}
    assert_equal s.length,3

    m = keyword_for 5,code

    assert_equal m.length,2
    
   
  end
end
