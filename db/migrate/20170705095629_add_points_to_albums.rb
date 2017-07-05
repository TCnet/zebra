class AddPointsToAlbums < ActiveRecord::Migration[5.0]
  def change
    add_column :albums, :points, :text
  end
end
