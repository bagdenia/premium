class Balance < ApplicationRecord
  belongs_to :user
  belongs_to :movement

  validates :balance, numericality: { greater_than_or_equal_to: 0, only_integer: true }
end
