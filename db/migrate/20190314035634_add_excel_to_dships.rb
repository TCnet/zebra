class AddExcelToDships < ActiveRecord::Migration[5.0]
  def change
    add_column :dships, :excelfile, :string
  end
end
