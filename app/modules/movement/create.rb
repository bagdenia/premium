class Movement
  class Create
    include Dry::Transaction
    TIMEOUT = 10

    Schema = Dry::Schema.Params do
      required(:user).value(type?: User)
      required(:datetime).value(type?: Time)
      required(:amount).value(type?: Integer)
    end

    step :validate_input
    step :create_movement

    def validate_input(input)
      result = Schema.call(input)
      return Failure(result.errors) if result.failure?

      Success(result.to_h)
    end

    def create_movement(user:, datetime:, amount:, **args)
      user.with_advisory_lock(user.lock_tag, timeout_seconds: TIMEOUT) do
        mov = user.movements.create!(datetime: datetime, amount: amount)
        return Success(user: user, operation: mov, **args)
      end
      Failure(:user_temporarily_locked)
    end
  end
end
