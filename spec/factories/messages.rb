# frozen_string_literal: true
FactoryBot.define do
  factory :message do
    chat_id { 1 }
    sender {'MyString'}
    receiver {'MyString'}
    message {'MyText'}
  end
end
