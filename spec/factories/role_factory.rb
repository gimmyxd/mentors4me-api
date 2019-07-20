# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    slug { Faker::Lorem.word }
  end
end
