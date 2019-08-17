class Movement < ApplicationRecord
  class BalanceValidator < ActiveModel::Validator
    def validate(record)
      return unless record.new_record?

      res = User::GetBalance.new.call(user: record.user)

      Dry::Matcher::ResultMatcher.call(res) do |result|
        result.success do |balance|
          return if balance + record.amount >= 0

          record.errors.add(:base, 'Not enough balance')
        end

        result.failure do |error|
          record.errors.add(:base, error.to_s)
        end
      end
    end
  end
end
