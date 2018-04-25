class AddAsizeToAlbums < ActiveRecord::Migration[5.0]
  def change
    add_column :albums, :asize, :text
  end
end
