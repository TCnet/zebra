class CreateXstocks < ActiveRecord::Migration[5.0]
  def change
    create_table :xstocks do |t|
      t.string :sku
      t.string :fnsku
      t.integer :homenum
      t.integer :fbanum
      t.integer :monthsold
      t.string :parentsku
      t.references :xstockplan, foreign_key: true

      t.timestamps
    end
  end
end
