class Organization < ApplicationRecord
  belongs_to :user
  validates :name, :asignee, :phone_number, :city, :description, presence: true
end
