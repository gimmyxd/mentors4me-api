# frozen_string_literal: true
class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(stream_name, messages)
    ActionCable.server.broadcast(stream_name, messages)
  end
end
