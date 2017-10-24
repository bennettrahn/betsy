class RemovePaymentInfoFromOrder < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :email
    remove_column :orders, :mailing_address
    remove_column :orders, :buyer_name
    remove_column :orders, :card_number
    remove_column :orders, :expiration
    remove_column :orders, :cvv
    remove_column :orders, :zipcode
  end
end
