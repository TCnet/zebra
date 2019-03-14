class CreateDships < ActiveRecord::Migration[5.0]
  def change
    create_table :dships do |t|
      t.string :ordernum
      t.string :dealnum
      t.string :sku
      t.integer :num
      t.string :name
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.string :phone
      t.string :email
      t.string :customize
      t.string :remark
      t.string :source
      t.string :tracknum
      t.float :weight

      t.timestamps
    end
  end
end
