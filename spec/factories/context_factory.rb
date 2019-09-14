# frozen_string_literal: true

FactoryBot.define do
  factory :context do
    description { Faker::Lorem.paragraph }
    mentor { FactoryBot.create(:user, :mentor_user) }
    organization { FactoryBot.create(:user, :organization_user) }
    status { nil }

    trait :accepted do
      status { CC::ACCEPTED }
    end

    trait :pending do
      status { CC::PENDING }
    end

    trait :rejected do
      status { CC::REJECTED }
    end
  end
end
