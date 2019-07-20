# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    role_id { 1 }

    before(:create, &:generate_authentication_token!)

    before(:create) do |user|
      new_assignments = []
      Array(user.role_id).each { |role_id| new_assignments << { role_id: role_id } }
      user.role_assignments_attributes = new_assignments
    end
  end

  trait :admin_user do
    role_id { 1 }
  end

  trait :mentor_user do
    after(:create) do |user|
      create(:mentor, user_id: user.id)
    end

    role_id { 2 }
  end

  trait :organization_user do
    after(:create) do |user|
      create(:organization, user_id: user.id)
    end

    role_id { 3 }
  end
end
