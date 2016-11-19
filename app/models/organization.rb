class Organization < ApplicationRecord
  has_one :user, dependent: :destroy
  validates :name, :asignee, :phone_number, :city, :description, presence: true
end
