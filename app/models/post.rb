class Post < ApplicationRecord
  belongs_to :profile, dependent: :destroy
  has_one :group, dependent: :destroy
  validates :title, :detail, :location, :capacity, presence: true

  #モデルではcurrent_userを使用できないためインスタンスメソッドとしてviewで渡す
  def owned_by?(user)
    profile.user == user
  end

end
