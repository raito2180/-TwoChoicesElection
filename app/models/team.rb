class Team < ApplicationRecord
  has_many :responses, dependent: :destroy
end
