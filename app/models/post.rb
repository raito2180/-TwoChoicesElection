class Post < ApplicationRecord
  belongs_to :profile
  has_one :group, dependent: :destroy
  validates :title, :detail, :location, :capacity, presence: true

  def owned_by?(user)
    profile.user == user
  end
end
