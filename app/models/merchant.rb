class Merchant < ApplicationRecord

  validates :username, presence: {message: "The username must be present"}

end
