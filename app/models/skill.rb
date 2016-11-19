class Skill < ApplicationRecord
  has_many :skill_assignments
  has_many :users, through: :skill_assignments
end
