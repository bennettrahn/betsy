class Product < ApplicationRecord

  has_many :order_products
  has_many :orders, through: :order_products
  has_many :reviews
  has_and_belongs_to_many :categories
  belongs_to :merchant

  scope :not_retired, -> { where(retired: false) }

  validates :name, presence: true, uniqueness: true

  validates :price, presence: true, numericality:{greater_than: 0}

  validates :inventory, presence: true, numericality:{greater_than_or_equal_to: 0}

  validates :category_ids, presence: {message: "Please select at least one category"}

  def check_inventory(quantity)
    if self.inventory >= quantity
      return true
    end
    return false
  end

  def decrease_inventory(quantity)
    self.inventory -= quantity
    self.save
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
