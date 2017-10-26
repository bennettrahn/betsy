class Order < ApplicationRecord
  has_many :order_products
  has_many :products, through: :order_products
  has_one :payment_info

  def order_complete?
    incomplete = 0
    self.order_products.each do |op|
      if op.status != "complete"
        incomplete += 1
      end
    end
    return incomplete == 0 ? true : false
  end

end
