class CreateStocks < ActiveRecord::Migration[5.0]
  def change
    create_table :stocks do |t|
      t.string :sku
      t.integer :num
      t.string :code
      t.string :size
      t.string :ussize
      t.references :inventory, foreign_key: true

      t.timestamps
    end
  end
end
