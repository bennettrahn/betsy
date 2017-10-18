class Product < ApplicationRecord
<<<<<<< HEAD
  has_many :order_products
=======
has_many :reviews
>>>>>>> lauren-reviews

  belongs_to :merchant

  validates :price, presence: true, numericality:{greater_than: 0}

  validates :name, presence: true, uniqueness: true

end
