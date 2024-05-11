class Response < ApplicationRecord
  attr_accessor :player_name
  belongs_to :user
  belongs_to :player,optional: true
  belongs_to :team,optional: true
  belongs_to :request
  belongs_to :season,optional: true
  with_options presence: true do
    validates :title
    validates :body
  end
end
