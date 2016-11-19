class Profile < ApplicationRecord
  has_one :user, dependent: :destroy
  validates :first_name, :last_name, :phone_number, :city, :description, presence: true
end
