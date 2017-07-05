class AddKeywordsToAlbums < ActiveRecord::Migration[5.0]
  def change
    add_column :albums, :keywords, :text
  end
end
