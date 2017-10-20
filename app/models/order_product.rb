class OrderProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, numericality: { less_than_or_equal_to: 5, greater_than_or_equal_to: 1}


end
