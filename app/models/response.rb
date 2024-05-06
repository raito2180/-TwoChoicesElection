class Response < ApplicationRecord
  belongs_to :user
  belongs_to :player
  belongs_to :team
  belongs_to :request
  belongs_to :season
end
