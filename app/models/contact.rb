class Contact < ApplicationRecord
  attr_accessor :email
  belongs_to :user
  has_many :responses, dependent: :destroy
  with_options presence: true do
    validates :name
    validates :subject
    validates :body
  end
end
