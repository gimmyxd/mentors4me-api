class Proposal < ApplicationRecord
  include TokenGenerator

  validates :email, :description, :status, presence: true
  validates :description, presence: true, length: { maximum: 500 }
  validates :email, uniqueness: true
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
  # returns - hash with user data
  def as_json(options = {})
    custom_response = {
      id: id,
      email: email,
      description: description,
      status: status,
      auth_token: auth_token
    }
    options.empty? ? custom_response : super
  end

  private

  def validate_uniqueness_of_user
    errors.add(:email, 'taken') if User.find_by(email: email).present?
  end
end
