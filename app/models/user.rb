class User < ApplicationRecord
  validates :name, presence: true

  has_many :movements

  def lock_tag
    "user_movement_lock_#{id}"
  end

  def currently_locked?
    advisory_lock_exists?(lock_tag)
  end
end
