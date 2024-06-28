class Membership < ApplicationRecord
  belongs_to :group
  belongs_to :profile

  enum status: { 参加: 0, 不参加: 1, 興味あり: 2 }
end
