# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    context { FactoryBot.create(:context) }
    message { Faker::Lorem.paragraph }
    sender_id { 1 }
    receiver_id { 2 }
    uuid { (0..4).to_a.map{|a| rand(4).to_s(4)}.join  }
    seen { false }
  end
end
