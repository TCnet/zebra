class CreateInoutplans < ActiveRecord::Migration[5.0]
  def change
    create_table :inoutplans do |t|
      t.string :name
      t.text :inout
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
