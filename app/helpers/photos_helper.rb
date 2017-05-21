module PhotosHelper

  def albums_for_select
    current_user.albums.collect { |m| [m.name, m.id] }
  end
end
