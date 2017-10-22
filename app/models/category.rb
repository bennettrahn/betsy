class Category < ApplicationRecord
  has_and_belongs_to_many :products

  validates :name, presence: {message: "Please enter a category name"}, uniqueness: true

  def self.spot
    spot = Product.all.sample
    return spot
  end

  # def self.view_by_category(category)
  #   Category.all.where(name:category).each do |holiday|
  #     holiday.products.each do |product|
  #       return product
  #     end
  #   end
  # end

end
