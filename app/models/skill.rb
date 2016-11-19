class Skill < ApplicationRecord
  has_many :skill_assignments
  has_many :users, trough: :skill_assignments
end
