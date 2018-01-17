class Bulletin < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :title, presence: true, length: {maximum: 50}
  validates :body, length: {maximum: 1000}

end
