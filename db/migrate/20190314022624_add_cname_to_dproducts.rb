class AddCnameToDproducts < ActiveRecord::Migration[5.0]
  def change
    add_column :dproducts, :cname, :string
  end
end
