class Season < ApplicationRecord
  has_many :responses, dependent: :destroy
end
