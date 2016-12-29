class Mentor < ApplicationRecord
  belongs_to :user
  has_many :skill_assignments
  has_many :skills, through: :skill_assignments
  validates :first_name, :last_name, :phone_number, :city, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 500 }
  accepts_nested_attributes_for :skill_assignments, allow_destroy: true
  attr_accessor :skill_id

  def assign_skills(skill_ids)
    new_assignments = []
    Array(skill_ids).each { |skill_id| new_assignments << { skill_id: skill_id } }
    self.skill_assignments_attributes = new_assignments
  end
end
