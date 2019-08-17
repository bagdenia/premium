class Movement < ApplicationRecord
  validates :datetime, :amount, presence: true

  belongs_to :user

  validates_with Movement::BalanceValidator

  # not allowed to update entries
  def readonly?
    new_record? ? false : true
  end
end
