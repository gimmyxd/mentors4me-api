# frozen_string_literal: true
class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from stream_name
    MessageBroadcastJob.perform_now(stream_name, messages)
  end

  def receive(data)
    data = data.fetch('message').slice('sender_id', 'receiver_id', 'message')
    data['context_id'] = context_id
    data['uuid'] = SecureRandom.uuid
    Message.create!(data)
  end

  private

  def messages
    @messages = Message.where(context_id: context_id).order(created_at: :asc).to_json
  end

  def stream_name
    "chat_channel_#{context_id}"
  end

  def context_id
    params.fetch('data').fetch('context_id')
  end
end
