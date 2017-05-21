class CreateAlbums < ActiveRecord::Migration[5.0]
  def change
    create_table :albums do |t|
      t.string :name
      t.string :summary
      t.string :coverimg
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :albums, [:user_id, :created_at]
  end
end
