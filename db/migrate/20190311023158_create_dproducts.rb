class CreateDproducts < ActiveRecord::Migration[5.0]
  def change
    create_table :dproducts do |t|
      t.string :sku
      t.string :name
      t.integer :parent
      t.string :name
      t.float :dprice
      t.integer :depotid
      t.float :weight
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
