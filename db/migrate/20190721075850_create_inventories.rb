class CreateInventories < ActiveRecord::Migration[5.0]
  def change
    create_table :inventories do |t|
      t.string :sku
      t.integer :normal
      t.integer :sizeup
      t.integer :sizedown
      t.integer :defect
      t.string :parentsku
      t.string :name
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
