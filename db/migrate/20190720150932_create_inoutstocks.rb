class CreateInoutstocks < ActiveRecord::Migration[5.0]
  def change
    create_table :inoutstocks do |t|
      t.string :sku
      t.integer :normal
      t.integer :sizeup
      t.integer :sizedown
      t.integer :defect
      t.boolean :actived
      t.references :inoutplan, foreign_key: true

      t.timestamps
    end
  end
end
