class Organization < ApplicationRecord
  belongs_to :user
  validates :name, :asignee, :phone_number, :city, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 500 }
end
