class AddQquuidToPhotos < ActiveRecord::Migration[5.0]
  def change
    add_column :photos, :qquuid, :string
  end
end
