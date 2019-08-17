class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :balance

  def balance
    res = User::GetBalance.new.call(user: object)

    Dry::Matcher::ResultMatcher.call(res) do |result|
      result.success do |balance|
        return balance
      end

      result.failure do |error|
        :balance_error
      end
    end
  end
end
