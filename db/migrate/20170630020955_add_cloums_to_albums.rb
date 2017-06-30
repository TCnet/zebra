class AddCloumsToAlbums < ActiveRecord::Migration[5.0]
  def change
    add_column :albums, :csize, :string
    add_column :albums, :ussize, :string
    add_column :albums, :brand, :string
    add_column :albums, :dnote, :text
    add_column :albums, :description, :text
    add_column :albums, :dname, :string
    add_column :albums, :fullname, :string
  end
end
