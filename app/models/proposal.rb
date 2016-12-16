class Proposal < ApplicationRecord
  belongs_to :user
  validates :email, :description, presence: true

  # proposals status
  ACCEPTED = 'accepted'.freeze
  REJECTED = 'rejected'.freeze
  PENDING = 'pending'.freeze

  # Filer proposals by status
  # /proposals?status='status'
  scope :status, ->(status) { where(status: status) }

  def accept
    self.status = ACCEPTED
    save!
  end

  def reject
    self.status = REJECTED
    save!
  end

  def pending
    self.status = PENDING
    save!
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
end
