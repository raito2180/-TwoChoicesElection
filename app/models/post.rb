class Post < ApplicationRecord
  belongs_to :profile, dependent: :destroy
  has_one :group, dependent: :destroy
  validates :title, :description, :location, :capacity, presence: true

end
