class CreateInventories < ActiveRecord::Migration[5.0]
  def change
    create_table :inventories do |t|
      t.string :name
      t.string :sku
      t.string :summary
      t.integer :pid
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
