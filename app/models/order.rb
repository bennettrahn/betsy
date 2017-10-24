class Order < ApplicationRecord
  has_many :order_products
  has_many :products, through: :order_products

  # validates :card_number, presence: true
  # validates :email, presence: true
  # validates :expiration, presence: true

  def products
    products = []
    order_products.each do |op|
      products << op.product
    end
    return products
  end
end
