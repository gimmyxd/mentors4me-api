# frozen_string_literal: true

class Context < ApplicationRecord
  include SharedMethods

  belongs_to :mentor, class_name: 'User', foreign_key: 'mentor_id' # rubocop:disable Rails/InverseOf
  belongs_to :organization, class_name: 'User', foreign_key: 'organization_id' # rubocop:disable Rails/InverseOf
  has_many :messages, dependent: :destroy
  validates :description, presence: true, length: { maximum: 500 }
  validates :mentor_id, presence: true
  validates :organization_id, presence: true
  validates :mentor_id, uniqueness: { scope: :organization_id }

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

  class << self
    def send_notification
      Context.find_each do |context|
        mentor = context.mentor
        organization = context.organization

        mentor_unread_messages = mentor_unread_messages(context)
        organization_unread_messages = organization_unread_messages(context)

        if mentor_unread_messages.present?
          MentorsMailer.send_unread_messages(
            mentor.email,
            name: organization.full_name,
            messages: mentor_unread_messages
          ).deliver_later
        end

        if organization_unread_messages.present?
          OrganizationsMailer.send_unread_messages(
            organization.email,
            name: mentor.full_name,
            messages: organization_unread_messages
          ).deliver_later
        end
      end
    end

    private

    def unread_messages(context, resource_type)
      resource = context.send(resource_type)
      context.messages.where(
        'updated_at > ? AND seen = ? AND sender_id = ?',
        Time.current - 1.hour, false, resource.id
      ).reorder(created_at: :asc).pluck(:created_at, :message).map do |pair|
        "#{SharedMethods.format_date(pair[0])}: #{pair[1]}"
      end.join(' <br> ').html_safe # rubocop:disable Rails/OutputSafety
    end

    def mentor_unread_messages(context)
      unread_messages(context, :mentor)
    end

    def organization_unread_messages(context)
      unread_messages(context, :organization)
    end
  end

  def accept!
    self.status = CC::ACCEPTED
    save!
  end

  def reject!
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
      mentor_id: mentor_id,
      mentor_email: mentor.email,
      organization_id: organization_id,
      organization_email: organization.email,
      status: status
    }
    options.empty? ? custom_response : super
  end
end
