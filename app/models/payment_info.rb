class PaymentInfo < ApplicationRecord
  has_one :order

  validates :name, presence: true
  validates :card_number, presence: true #numericality
  validates :email, presence: true
  validates_format_of :email, :with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: "Please enter your email in this format: example@example.com"
  validates :expiration, presence: true
  # could be cool to format it like a date?
  validates :mailing_address, presence: true
  validates :cvv, presence: true #numericality
  validates :zipcode, presence: true #numericality
end
