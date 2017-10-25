class AddDefaultValueToRetired < ActiveRecord::Migration[5.1]
  def change
    change_column :products, :retired, :boolean, :default => false
  end
end
