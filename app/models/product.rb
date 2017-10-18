class Product < ApplicationRecord
  has_many :orderitems
  
  validates :price, presence: true, numericality:{greater_than: 0}

  validates :name, presence: true, uniqueness: true

end
