class Proposal < ApplicationRecord
  include TokenGenerator

  validates :proposer_first_name, :proposer_last_name, :proposer_email, :proposer_phone_number,
            :mentor_first_name, :mentor_last_name, :mentor_organization, :mentor_email, :mentor_phone_number,
            :status, presence: true
  validates :reason, presence: true, length: { maximum: 500 }
  validates :proposer_first_name, :proposer_last_name, :proposer_phone_number,
            :mentor_first_name, :mentor_organization, :mentor_email, :mentor_phone_number,
            length: { maximum: 50 }
  validates :proposer_email, :mentor_email, length: { maximum: 100 }
  validates :mentor_email, uniqueness: true
  validate :validate_uniqueness_of_user
  validates :auth_token, uniqueness: true, allow_nil: true

  # Filer proposals by status
  # /proposals?status='status'
  scope :status, ->(status) { where(status: status) }

  def accept
    return false unless pending?
    generate_authentication_token!
    self.status = CP::ACCEPTED
    save
  end

  def reject
    return false unless pending?
    self.status = CP::REJECTED
    save
  end

  def pending
    self.status = CP::PENDING
  end

  def pending?
    status == CP::PENDING
  end

  def accepted?
    status == CP::ACCEPTED
  end

  def rejected?
    status == CP::REJECTED
  end

  # Public: models JSON representation of the object
  # _options - parameter that is provided by the standard method
  # returns - hash with proposal data
  def as_json(options = {})
    custom_response = {
      id: id,
      proposer_first_name: proposer_first_name,
      proposer_last_name: proposer_last_name,
      proposer_email: proposer_email,
      proposer_phone_number: proposer_phone_number,
      mentor_first_name: mentor_first_name,
      mentor_last_name: mentor_last_name,
      mentor_organization: mentor_organization,
      mentor_email: mentor_email,
      mentor_phone_number: mentor_phone_number,
      mentor_facebook: mentor_facebook,
      mentor_linkedin: mentor_linkedin,
      reason: reason,
      auth_token: auth_token
    }
    options.empty? ? custom_response : super
  end

  private

  def validate_uniqueness_of_user
    errors.add(:mentor_email, 'taken') if User.find_by(email: mentor_email).present?
  end
end
