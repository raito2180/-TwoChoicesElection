class Group < ApplicationRecord
  belongs_to :post
  has_many :memberships, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :profiles, through: :memberships
  enum status: {参加: 0, 不参加: 1, 興味あり: 2}
end
