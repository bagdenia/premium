class Movement < ApplicationRecord
  validates :datetime, :amount, presence: true

  belongs_to :user
end
