class CreateEtemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :etemplates do |t|
      t.string :name
      t.text :title
      t.boolean :isused
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
