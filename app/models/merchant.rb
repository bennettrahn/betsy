class Merchant < ApplicationRecord

  has_many :products

  validates :username, presence: {message: "Please enter a username"}, uniqueness: true

  validates :email, presence: {message: "Please enter an email"}, uniqueness: true

  validates_format_of :email, :with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: "Please enter your email in this format: example@example.com"
  def self.from_auth_hash(provider, auth_hash)
    merchant = new
    merchant.provider = provider
    merchant.uid = auth_hash['uid']
    merchant.name = auth_hash['info']['name']
    merchant.email = auth_hash['info']['email']
    merchant.username = auth_hash['info']['nickname']

    return merchant
  end


  # def merchant_orders
  #   Order.joins(:products).where(products: {merchant: merchant})
  # end

  def relevant_orders
    relevant_orders = []
    Order.all.each do |order|
      relevant_order_products = order.order_products.select { |op|
        op.product.merchant == self
      }
      if relevant_order_products.length > 0
        relevant_orders << {
          order: order,
          order_products: relevant_order_products
        }
      end
    end
    return relevant_orders
  end

  def sort_orders_by_status(status)
    merchants_orders = self.relevant_orders
    return merchants_orders.select { |order| order[:order].status == status}
  end

  def total_revenue(status)
    orders = sort_orders_by_status(status)
    sum = 0
    orders.each do |order|
      sum += order[:order].order_total(merchant: self)
    end
    return sum
  end

end
