# frozen_string_literal: true
class Mentor < ApplicationRecord
  belongs_to :user
  has_many :skill_assignments
  has_many :skills, through: :skill_assignments
  validates :first_name, :last_name, :phone_number, :city, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 500 }
  accepts_nested_attributes_for :skill_assignments, allow_destroy: true
  attr_accessor :skill_id
  after_validation :validate_skills

  def assign_skills(skill_ids)
    self.skills = Skill.where(id: skill_ids)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def validate_skills
    errors.add(:skills, :blank) if skills.empty?
  end
end
