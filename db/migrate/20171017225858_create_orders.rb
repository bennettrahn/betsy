class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :status
      t.string :email
      t.string :mailing_address
      t.string :buyer_name
      t.string :card_number
      t.string :expiration
      t.string :cvv
      t.string :zipcode

      t.timestamps
    end
  end
end
