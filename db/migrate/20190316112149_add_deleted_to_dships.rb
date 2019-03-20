class AddDeletedToDships < ActiveRecord::Migration[5.0]
  def change
    add_column :dships, :deleted, :bool
  end
end
