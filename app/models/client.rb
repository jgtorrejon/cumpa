class Client < ApplicationRecord
  has_many :messages
  has_one :credit_status
end
