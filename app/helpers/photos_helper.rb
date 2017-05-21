module PhotosHelper

  def albums_for_select
    current_user.albums.collect { |m| [m.name, m.id] }
  end

  def geturl(img)
    request.protocol+request.host_with_port+img
  end
end
