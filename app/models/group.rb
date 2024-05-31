class Group < ApplicationRecord
  belongs_to :post
  has_many :memberships, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :profiles, through: :memberships
end
