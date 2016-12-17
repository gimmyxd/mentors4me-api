class Proposal < ApplicationRecord
  belongs_to :user
  validates :email, :description, presence: true
  validates :invitation_token, uniqueness: true, allow_nil: true

  # proposals status
  ACCEPTED = 'accepted'.freeze
  REJECTED = 'rejected'.freeze
  PENDING = 'pending'.freeze

  # Filer proposals by status
  # /proposals?status='status'
  scope :status, ->(status) { where(status: status) }

  def accept
    return false unless pending?
    generate_invitation_token!
    self.status = ACCEPTED
    save!
  end

  def reject
    return false unless pending?
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

  # Public: generates an invitation token
  # returns - token for the user
  def generate_invitation_token!
    loop do
      self.invitation_token = Devise.friendly_token
      self.invitation_token_created_at = Time.now
      break invitation_token unless self.class.exists?(invitation_token: invitation_token)
    end
  end
end
