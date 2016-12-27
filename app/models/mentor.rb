class Mentor < ApplicationRecord
  belongs_to :user
  has_many :skill_assignments
  has_many :skills, through: :skill_assignments
  validates :first_name, :last_name, :phone_number, :city, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 500 }
end
