class Merchant < ApplicationRecord

  validates :username, presence: {message: "Please enter a username"}

  validates :email, presence: {message: "Please enter an email"}

  validates_format_of :email, :with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: "Please enter your email in this format: example@example.com"
end
