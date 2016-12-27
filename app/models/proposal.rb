class Proposal < ApplicationRecord
  validates :email, :description, :status, presence: true
  validates :invitation_token, uniqueness: true, allow_nil: true

  # Filer proposals by status
  # /proposals?status='status'
  scope :status, ->(status) { where(status: status) }

  def accept
    return false unless pending?
    generate_invitation_token!
    self.status = CP::ACCEPTED
    save!
  end

  def reject
    return false unless pending?
    self.status = CP::REJECTED
    save!
  end

  def pending(save = true)
    self.status = CP::PENDING
    save! if save
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
