class AddImgruleToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :imgrule, :string
  end
end
