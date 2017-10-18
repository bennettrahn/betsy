class Product < ApplicationRecord

  belongs_to :merchant

  validates :price, presence: true, numericality:{greater_than: 0}

  validates :name, presence: true, uniqueness: true

end
