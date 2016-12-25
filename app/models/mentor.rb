class Mentor < ApplicationRecord
  belongs_to :user
  has_many :skill_assignments
  has_many :skills, through: :skill_assignments
  validates :first_name, :last_name, :phone_number, :city, :description, presence: true
end
