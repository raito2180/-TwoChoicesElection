class Player < ApplicationRecord
  has_many :responses, dependent: :destroy
end
