class AddPricestockToAlbums < ActiveRecord::Migration[5.0]
  def change
    add_column :albums, :price, :text
    add_column :albums, :stock, :text
  end
end
