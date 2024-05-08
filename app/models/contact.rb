class Contact < ApplicationRecord
  attr_accessor :email
  belongs_to :user
  with_options presence: true do
    validates :name
    validates :subject
    validates :body
  end
end
