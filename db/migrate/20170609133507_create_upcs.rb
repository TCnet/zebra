class CreateUpcs < ActiveRecord::Migration[5.0]
  def change
    create_table :upcs do |t|
      t.string :name
      t.string :bool
      t.string :isused
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
