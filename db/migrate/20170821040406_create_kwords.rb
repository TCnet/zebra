class CreateKwords < ActiveRecord::Migration[5.0]
  def change
    create_table :kwords do |t|
      t.string :name
      t.text :instr
      t.text :outstr
      t.string :lefwords
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
