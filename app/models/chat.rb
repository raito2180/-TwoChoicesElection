class Chat < ApplicationRecord
  belongs_to :group
  belongs_to :profile
end
