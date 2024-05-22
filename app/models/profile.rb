class Profile < ApplicationRecord
  belongs_to :user
  enum gender: { male: 0, female: 1, secret: 2 }
end
