class Request < ApplicationRecord
  has_many :responses, dependent: :destroy
  validates :name, presence: true
end
