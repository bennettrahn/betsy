class CreateReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.string :text
      t.integer :product_id 

      t.timestamps
    end
  end
end
