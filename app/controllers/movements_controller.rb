class MovementsController < ApplicationController
  before_action :find_user
  before_action :parse_datetime, only: :create

  def index
    @movements = @user.movements
    render json: @movements
  end

  def create
    input = {
      user: @user,
      datetime: @datetime,
      amount: movement_params[:amount]&.to_i
    }

    res = Movement::Create.new.call(input)

    Dry::Matcher::ResultMatcher.call(res) do |result|
      result.success do |movement|
        render json: movement, status: :created
      end

      result.failure do |error|
        render json: error, status: :internal_server_error
      end
    end
  end

  private

  def movement_params
    @movement_params ||= begin
      attrs = params.require(:data).require(:attributes)
                    .permit(:amount, :datetime)
      { amount: attrs.require(:amount),
        datetime: attrs.require(:datetime) }
    end
  end

  def find_user
    @user = User.find(params[:user_id])
  end

  def parse_datetime
    @datetime = Time.parse(movement_params[:datetime])
  rescue ArgumentError => _e
    render(json: { error: 'Invalid datetime format' }, status: :bad_request)
  end
end
