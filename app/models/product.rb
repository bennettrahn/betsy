class Product < ApplicationRecord

  has_many :order_products
  has_many :orders, through: :order_products
  has_many :reviews
  has_and_belongs_to_many :categories


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

  def average_rating
    avg = 0
    count = 0

    reviews.each do |review|
      if review.rating > 0
        count += 1
        avg += review.rating
      end
    end
    if count == 0
      return 0
    end
    return avg / count
  end
end
