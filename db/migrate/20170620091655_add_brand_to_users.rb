class AddBrandToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :brand, :string
    add_column :users, :note, :text
  end
end
