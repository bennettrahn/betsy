class AddRetiredTo < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :retired, :boolean
  end
end
