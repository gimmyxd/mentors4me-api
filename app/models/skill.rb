class Skill < ApplicationRecord
  has_many :skill_assignments
  has_many :mentors, through: :skill_assignments

  # Name validation
  validates :name, presence: true, uniqueness: true

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
