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

  def relevant_orders
    relevant_orders = []
    Order.all.each do |order|
      relevant_products = order.products.select { |product|
        product.merchant == self
      }
      if relevant_products.length > 0
        relevant_orders << {
          order: order,
          products: relevant_products
        }
      end
    end
    return relevant_orders
  end
end
