class Movement < ApplicationRecord
  class BalanceValidator < ActiveModel::Validator
    def validate(record)
      return unless record.new_record?

      User::GetBalance.new.call(user: record.user) do |result|
        result.success do |balance|
          return if record.amount >= balance
          record.errors.add(:base, 'Not enough balance')
        end

        result.failure do |validation|
          record.errors.add(:base, validation.to_s)
        end
      end
    end
  end
end
