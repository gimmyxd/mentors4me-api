class Context < ApplicationRecord
  belongs_to :profile
  belongs_to :organization
  validates :description, presence: true
  validates :profile_id, presence: true
  validates :organization_id, presence: true

  # Filer contexts by profile_id
  # /contexts?profile_id=1
  scope :profile_id, ->(profile_id) { where(profile_id: profile_id) }

  # Filer contexts by organization_id
  # /contexts?organization_id=1
  scope :organization_id, ->(organization_id) { where(organization_id: organization_id) }

  # Filer contexts by accepted
  # /contexts?accepted=true
  scope :accepted, ->(accepted) { where(accepted: accepted) }

  # Filter contexts by start date
  # /contexts?start_date="2016-01-04"
  scope :start_date, ->(start_date) { where('created_at >= ?', start_date.to_date) }

  # Filter contexts by end date
  # /contexts?end_date="2016-01-04"
  scope :end_date, ->(end_date) { where('created_at <= ?', end_date.to_date) }

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
