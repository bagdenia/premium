class User
  class GetBalance
    include Dry::Transaction

    Schema = Dry::Schema.Params do
      required(:user).value(type?: User)
    end

    step :validate_input
    map :fetch_balance
    map :fetch_new_movements
    map :calculate_balance
    step :update_balance

    def validate_input(input)
      result = Schema.call(input)
      return Failure(result.errors) if result.failure?

      Success(result.to_h)
    end

    def fetch_balance(user:, **args)
      balance = Balance.where(user: user).order(movement_id: :asc).last
      { user: user, balance: balance, **args }
    end

    def fetch_new_movements(user:, balance:, **args)
      new_movements = Movement.order(id: :asc)
                              .where(user: user)
                              .where('id > ?', (balance&.movement_id || -1))

      { user: user, balance: balance, new_movements: new_movements, **args }
    end

    def calculate_balance(balance:, new_movements:, **args)
      balance = balance.blank? ? 0 : balance.balance

      new_movements.each { |ml| balance += ml.amount }

      { balance: balance, new_movements: new_movements, **args }
    end

    def update_balance(user:, balance:, new_movements:)
      return Success(balance) if new_movements.blank?

      new_balance = Balance.new(user: user,
                                balance: balance,
                                movement: new_movements.last)

      if new_balance.save
        Success(balance)
      else
        Failure(new_balance.errors.messages)
      end
    end
  end
end
