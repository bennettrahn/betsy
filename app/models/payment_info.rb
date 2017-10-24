class PaymentInfo < ApplicationRecord
  has_one :order

  validates :buyer_name, presence: true
  validates :email, presence: true
  validates_format_of :email, :with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: "Please enter your email in this format: example@example.com"
  validates :card_number, presence: true, length: {minimum: 4} #numericality
  validates :expiration, presence: true
  # could be cool to format it like a date?
  validates :mailing_address, presence: true
  validates :cvv, presence: true #numericality
  validates :zipcode, presence: true #numericality

  def last_four_cc
    last_four_cc = self.card_number.slice(-4..-1)
    return last_four_cc
  end
end
