class AddPlannumToXstock < ActiveRecord::Migration[5.0]
  def change
    add_column :xstocks, :name, :string
    add_column :xstocks, :plannum, :integer
  end
end
