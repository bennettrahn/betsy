# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

# MERCHANTS #

MERCHANT_FILE = Rails.root.join('db','seed_data','merchants.csv')
puts "Loading raw media data from #{MERCHANT_FILE}"

merchant_failures = []
CSV.foreach(MERCHANT_FILE, :headers => true) do |row|
  merchant = Merchant.new
  merchant.name = row['name']
  merchant.username = row['username']
  merchant.email = row['email']
  merchant.provider = row['provider']
  merchant.uid = row['uid']
  puts "Created merchant: #{merchant.inspect}"
  successful = merchant.save
  if !successful
    merchant_failures << merchant
  end
end

puts "Added #{Merchant.count} merchant records"
puts "#{merchant_failures.length} merchants failed to save"

# CATEGORIES #

CATEGORY_FILE = Rails.root.join('db','seed_data','categories.csv')
puts "Loading raw media data from #{CATEGORY_FILE}"

category_failures = []
CSV.foreach(CATEGORY_FILE, :headers => true) do |row|
  category = Category.new
  category.name = row['name']
  puts "Created category: #{category.inspect}"
  successful = category.save
  if !successful
    category_failures << category
  end
end

puts "Added #{Category.count} category records"
puts "#{category_failures.length} categories failed to save"

# PRODUCT CATEGORIES #

PC_FILE = Rails.root.join('db','seed_data','product_category.csv')
puts "Loading raw media data from #{PC_FILE}"

product_category_failures = []
CSV.foreach(PC_FILE, :headers => true) do |row|
  product_category = ProductCategory.new
  product_category.product_id = row['product_id']
  product_category.category_id = row['category_id']
  puts "Created merchant: #{product_category.inspect}"
  successful = product_category.save
  if !successful
    product_category_failures << product_category
  end
end

puts "Added #{ProductCategory.count} product_category records"
puts "#{product_category_failures.length} product_category failed to save"

# PRODUCTS #

PRODUCT_FILE = Rails.root.join('db','seed_data','products.csv')
puts "Loading raw media data from #{PRODUCT_FILE}"

product_failures = []
CSV.foreach(PRODUCT_FILE, :headers => true) do |row|
  product = Product.new
  product.name = row['name']
  product.price = row['price']
  product.inventory = row['inventory']
  product.photo_url = row['photo_url']
  product.description = row['description']
  product.merchant_id = row['merchant_id']
  puts "Created product: #{product.inspect}"
  successful = product.save
  if !successful
    product_failures << product
  end
end

puts "Added #{Product.count} product records"
puts "#{product_failures.length} productd failed to save"

# REVIEWS #

# REVIEW_FILE = Rails.root.join('db','seed_data','review.csv')
# puts "Loading raw media data from #{REVIEW_FILE}"
#
# review_failures = []
# CSV.foreach(REVIEW_FILE, :headers => true) do |row|
#   review = Review.new
#   review.review = row['review']
#   review.rating = row['rating']
#   review.product_id = row['product']
#   puts "Created review: #{review.inspect}"
#   successful = review.save
#   if !successful
#     review_failures << review
#   end
# end
#
# puts "Added #{Review.count} review records"
# puts "#{review_failures.length} reviews failed to save"


# ORDER ITEMS #

# order_failures = []
# 10.times do
#   order = Order.new
#   successful = order.save
#   if !successful
#     order_failures << order_item
#   end
#   puts "Created order: #{order.inspect}"
# end
# puts "Added #{Order.count} order item records"
# puts "#{order_failures.length} orders failed to save"

# ORDER ITEMS #

# ORDER_ITEMS_FILE = Rails.root.join('db','seed_data','order_items.csv')
# puts "Loading raw media data from #{ORDER_ITEMS_FILE}"
#
# order_items_failures = []
# CSV.foreach(ORDER_ITEMS_FILE, :headers => true) do |row|
#   order_item = OrderItem.new
#   order_item.product_id = row['product_id']
#   order_item.order_id = row['order_id']
#   order_item.quantity = row['quantity']
#
#   puts "Created order item: #{order_item.inspect}"
#   successful = order_item.save
#   if !successful
#     order_items_failures << order_item
#   end
# end
#
# puts "Added #{OrderItem.count} order item records"
# puts "#{order_items_failures.length} order items failed to save"

# Payments #

# PAYMENT_FILE = Rails.root.join('db','seed_data','payment.csv')
# puts "Loading raw payment data from #{PAYMENT_FILE}"
#
# d1 = Date.new(2017,5,8)
#
# payment_failures = []
# CSV.foreach(PAYMENT_FILE, :headers => true) do |row|
#   payment = Payment.new
#   payment.email = row['email']
#   payment.mailing_address = row['mailing_address']
#   payment.cc_name = row['cc_name']
#   payment.cc_expiration = d1
#   payment.cc_number = row['cc_number']
#   payment.cc_ccv = row['cc_ccv']
#   payment.billing_zip = row['billing_zip']
#   payment.order_id = row['order_id']
#
#   puts "Created payment: #{payment.inspect}"
#   successful = payment.save
#   if !successful
#     payment_failures << payment
#   end
# end
#
# puts "Added #{Payment.count} order item records"
# puts "#{payment_failures.length} payments failed to save"
