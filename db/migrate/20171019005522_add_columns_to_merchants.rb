class AddColumnsToMerchants < ActiveRecord::Migration[5.1]
  def change
    add_column :merchants, :name, :string
    add_column :merchants, :provider, :string, null: false
    add_column :merchants, :uid, :string, null: false
  end
end
