class Movement < ApplicationRecord
  validates :datetime, :amount, presence: true

  belongs_to :user

  validates_with Movement::BalanceValidator

  # менять уже созданные движения запрещаем
  def readonly?
    new_record? ? false : true
  end
end
