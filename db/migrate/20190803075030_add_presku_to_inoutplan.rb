class AddPreskuToInoutplan < ActiveRecord::Migration[5.0]
  def change
    add_column :inoutplans, :presku, :string
  end
end
