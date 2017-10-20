class ChangeProductInventoryToInteger < ActiveRecord::Migration[5.1]
  def change
    change_column(:products, :inventory, 'integer USING CAST(inventory AS integer)')

  end
end
