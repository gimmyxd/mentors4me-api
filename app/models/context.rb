class Context < ApplicationRecord
  belongs_to :profile
  belongs_to :organization
  validates :description, presence: true
  validates :profile_id, presence: true
  validates :organization_id, presence: true

  # context status
  ACCEPTED = 'accepted'.freeze
  REJECTED = 'rejected'.freeze
  PENDING = 'pending'.freeze

  STATUES = [ACCEPTED, PENDING, REJECTED].freeze

  # Filer contexts by profile_id
  # /contexts?profile_id=1
  scope :profile_id, ->(profile_id) { where(profile_id: profile_id) }

  # Filer contexts by organization_id
  # /contexts?organization_id=1
  scope :organization_id, ->(organization_id) { where(organization_id: organization_id) }

  # Filer context by status
  # /contexts?status='status'
  scope :status, ->(status) { where(status: status) }

  # Filter contexts by start date
  # /contexts?start_date="2016-01-04"
  scope :start_date, ->(start_date) { where('created_at >= ?', start_date.to_date) }

  # Filter contexts by end date
  # /contexts?end_date="2016-01-04"
  scope :end_date, ->(end_date) { where('created_at <= ?', end_date.to_date) }

  def accept
    self.status = ACCEPTED
    save!
  end

  def reject
    self.status = REJECTED
    save!
  end

  def pending(save = true)
    self.status = PENDING
    save! if save
  end

  def pending?
    status == PENDING
  end

  def accepted?
    status == ACCEPTED
  end

  def rejected?
    status == REJECTED
  end

  # Public: models JSON representation of the object
  # _options - parameter that is provided by the standard method
  # returns - hash with user data
  def as_json(options = {})
    custom_response = {
      id: id,
      description: description,
      profile_id:  profile_id,
      organization_id: organization_id,
      status: status
    }
    options.empty? ? custom_response : super
  end
end
