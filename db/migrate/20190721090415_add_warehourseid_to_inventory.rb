class AddWarehourseidToInventory < ActiveRecord::Migration[5.0]
  def change
    add_reference :inventories, :warehouse, foreign_key: true
  end
end
