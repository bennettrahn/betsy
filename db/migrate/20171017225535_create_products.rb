class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.integer :price
      t.integer :merchant_id
      t.string :inventory
      t.string :photo_url

      
      t.timestamps
    end
  end
end
