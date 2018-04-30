class ChangeForAlbums < ActiveRecord::Migration[5.0]
  def change
    change_column :albums, :price, :text ,default: " "
  end
end
