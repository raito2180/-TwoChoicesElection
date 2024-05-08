class Response < ApplicationRecord
  attr_accessor :player_name
  belongs_to :user
  belongs_to :player
  belongs_to :team
  belongs_to :request
  belongs_to :season
  with_options presence: true do
    validates :title
    validates :body
  end
end
