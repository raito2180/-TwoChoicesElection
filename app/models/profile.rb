class Profile < ApplicationRecord
  has_one_attached :avatar
  validates :avatar, content_type: { in: %w[image/jpeg image/gif image/png],
                     message: "有効なフォーマットではありません" },
                     size: { less_than: 5.megabytes, message: " 5MBを超える画像はアップロードできません" }

  belongs_to :user
  enum gender: { male: 0, female: 1, secret: 2 }

  self.ignored_columns = [:image]
end
