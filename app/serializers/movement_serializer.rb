class MovementSerializer < ActiveModel::Serializer
  attributes :name, :datetime, :amount

  def name
    object.user.name
  end
end
