# frozen_string_literal: true

FactoryBot.define do
  factory :context do
    description { Faker::Lorem.paragraph }
    before(:create) do |c|
      c.mentor = FactoryBot.create(:user, :mentor_user)
      c.organization = FactoryBot.create(:user, :organization_user)
    end
  end
end
