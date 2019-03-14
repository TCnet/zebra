class AddUserToDships < ActiveRecord::Migration[5.0]
  def change
    add_reference :dships, :user, foreign_key: true
  end
end
