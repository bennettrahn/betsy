class AddOrderIdToPaymentInfo < ActiveRecord::Migration[5.1]
  def change
    add_column :payment_infos, :order_id, :integer
    add_column :orders, :payment_info_id, :integer
  end
end
