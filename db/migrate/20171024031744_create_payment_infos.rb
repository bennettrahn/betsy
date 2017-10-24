class CreatePaymentInfos < ActiveRecord::Migration[5.1]
  def change
    create_table :payment_infos do |t|
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
