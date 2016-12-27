class Context < ApplicationRecord
  belongs_to :mentor
  belongs_to :organization
  validates :description, presence: true
  validates :mentor_id, presence: true
  validates :organization_id, presence: true

  # Filer contexts by mentor_id
  # /contexts?mentor_id=1
  scope :mentor_id, ->(mentor_id) { where(mentor_id: mentor_id) }

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
    self.status = CC::ACCEPTED
    save!
  end

  def reject
    self.status = CC::REJECTED
    save!
  end

  def pending
    self.status = CC::PENDING
  end

  def pending?
    status == CC::PENDING
  end

  def accepted?
    status == CC::ACCEPTED
  end

  def rejected?
    status == CC::REJECTED
  end

  # Public: models JSON representation of the object
  # _options - parameter that is provided by the standard method
  # returns - hash with user data
  def as_json(options = {})
    custom_response = {
      id: id,
      description: description,
      mentor_id:  mentor_id,
      organization_id: organization_id,
      status: status
    }
    options.empty? ? custom_response : super
  end
end
