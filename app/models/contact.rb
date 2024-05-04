class Contact < ApplicationRecord
  attr_accessor :email
  belongs_to :user
end
