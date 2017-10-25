class Category < ApplicationRecord
  has_and_belongs_to_many :products

  validates :name, presence: {message: "Please enter a category name"}, uniqueness: true

  def self.spot
    spot = Product.all.sample
    return spot
  end

  def self.root_page_seasonal_pick
    category = "Halloween"
    all_products_for_season_cat = []

    Category.all.where(name: category).each do |c|

      c.products.not_retired.each do |prod|
        all_products_for_season_cat << prod
      end
    end

    return all_products_for_season_cat

  end

  # def self.view_by_category
  #   Category.all.each do |category|
  #     category.products.each do |product|
  #       return product
  #     end
  #   end
  # end

end
