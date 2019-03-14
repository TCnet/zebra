class AddPriceSenderToDships < ActiveRecord::Migration[5.0]
  def change
    add_column :dships, :price, :float
    add_column :dships, :sender, :string
  end
end
