class Order < ApplicationRecord
  has_many :order_products


  def products
    products = []
    order_products.each do |op|
      products << op.product
    end
    return products
  end
end
