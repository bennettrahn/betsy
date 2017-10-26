class OrderProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product
  has_one :merchant, through: :product

  validates :quantity, numericality: {greater_than_or_equal_to: 1}

  def subtotal
    return product.price * quantity
  end
end
