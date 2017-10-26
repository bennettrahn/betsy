class Order < ApplicationRecord
  has_many :order_products
  has_many :products, through: :order_products
  has_one :payment_info

  scope :not_retired, -> { where(retired: false) }


  def order_complete?
    incomplete = 0

    self.order_products.each do |op|
      if op.status != "complete"
        incomplete += 1
      end
    end
    return incomplete == 0 ? true : false
  end

  def order_total(merchant: nil)
    total = 0
    ops = nil
    if merchant
      ops = self.order_products.select { |op|
        op.merchant == merchant
      }
    else
      ops = self.order_products
    end
    ops.each do |order_product|
      total += order_product.subtotal
    end
    return total
  end

end
