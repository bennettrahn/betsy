class Product < ApplicationRecord

  has_many :order_products
  has_many :reviews

  belongs_to :merchant

  validates :price, presence: true, numericality:{greater_than: 0}

  validates :name, presence: true, uniqueness: true



  def check_inventory(quantity)
    if self.inventory >= quantity
      return true
    end
    return false
  end


  def decrease_inventory(quantity)
    self.inventory -= quantity
  end
end
