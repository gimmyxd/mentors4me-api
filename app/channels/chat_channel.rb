class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from stream_name
    MessageBroadcastJob.perform_later(stream_name, messages)
  end

  def receive(data)
    data = data.fetch('message').slice('sender_id', 'receiver_id', 'message')
    data['context_id'] = context_id
    Message.create!(data)
  end

  private

  def messages
    @messages = Message.where(context_id: context_id).to_json
  end

  def stream_name
    "chat_channel_#{context_id}"
  end

  def context_id
    params.fetch('data').fetch('context_id')
  end
end
