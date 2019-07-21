class AddActivedToInoutplan < ActiveRecord::Migration[5.0]
  def change
    add_column :inoutplans, :actived, :boolean
  end
end
