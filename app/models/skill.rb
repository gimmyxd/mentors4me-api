# frozen_string_literal: true

class Skill < ApplicationRecord
  has_many :skill_assignments, dependent: :destroy
  has_many :mentors, through: :skill_assignments, dependent: :restrict_with_exception

  # Name validation
  validates :name, presence: true, uniqueness: true, length: { maximum: 100 }

  # Public: models JSON representation of the object
  # _options - parameter that is provided by the standard method
  # returns - hash with team data
  def as_json(_options = {})
    {
      id: id,
      name: name
    }
  end
end
