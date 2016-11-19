class Context < ApplicationRecord
  belongs_to :profile
  belongs_to :organization
  validates :description, presence: true
  validates :profile_id, presence: true
  validates :organization_id, presence: true

  # Public: models JSON representation of the object
  # _options - parameter that is provided by the standard method
  # returns - hash with user data
  def as_json(options = {})
    custom_response = {
      id: id,
      description: description,
      profile_id:  profile_id,
      organization_id: organization_id,
      accepted: accepted
    }
    options.empty? ? custom_response : super
  end
end
