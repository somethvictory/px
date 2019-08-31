class User < ApplicationRecord
  validates :name,          presence: true
  validates :date_of_birth, presence: true

  belongs_to :country

  has_many   :transactions
end
