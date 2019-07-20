# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :context
  validates :message, presence: true, length: { maximum: 10_000 }
  validates :sender_id, :receiver_id, :uuid, presence: true
  after_create_commit do
    MessageBroadcastJob.perform_now(stream_name, Array(self).to_json)
  end

  # Public: models JSON representation of the object
  # _options - parameter that is provided by the standard method
  # returns - hash with message data
  def as_json(options = {})
    custom_response = {
      conversation_id: context_id,
      message_id: uuid,
      sender: sender_name,
      sender_id: sender_id,
      receiver: reciever_name,
      receiver_id: receiver_id,
      message: message,
      seen: seen,
      sent_at: created_at.to_s
    }
    options.empty? ? custom_response : super
  end

  def sender_name
    User.find(sender_id).full_name
  end

  def reciever_name
    User.find(receiver_id).full_name
  end

  private

  def stream_name
    "chat_channel_#{context_id}"
  end
end
