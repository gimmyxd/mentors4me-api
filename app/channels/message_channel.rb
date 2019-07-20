# frozen_string_literal: true

class MessageChannel < ApplicationCable::Channel
  def subscribed
    stream_from receiver_stream_name
    MessageBroadcastJob.perform_now(receiver_stream_name, last_message)
  end

  def receive(data)
    message = Message.find_by(uuid: uuid(data))
    message.update(seen: true)
    MessageBroadcastJob.perform_now(sender_stream_name, message.to_json(only: :uuid))
  end

  private

  def uuid(data)
    data.fetch('message').fetch('message_id')
  end

  def last_message
    message = Message.where(
      context_id: context_id,
      sender_id: sender_id,
      seen: true
    ).last
    message.to_json(only: :uuid) if message.present?
  end

  def sender_stream_name
    "message_channel_#{context_id}_#{sender_id}"
  end

  def receiver_stream_name
    "message_channel_#{context_id}_#{receiver_id}"
  end

  def context_id
    params.fetch('data').fetch('context_id')
  end

  def receiver_id
    params.fetch('data').fetch('user_id')
  end

  def sender_id
    @sender_id ||= Message.where(context_id: context_id, receiver_id: receiver_id).last.try(:sender_id)
  end
end
