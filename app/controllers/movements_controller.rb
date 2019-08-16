class MovementsController < ApplicationController
  before_action :find_user

  def index
    @movements = @user.movements
    render json: @movements
  end

  private

  def operation_params
    params.require(:data).require(:attributes).permit(:value, :datetime).to_h.symbolize_keys
  end

  def find_user
    @user = User.find(params[:user_id])
  end
end
