require './spec/support/test_methods'

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    role_id TestMethods.find_or_create_role(Custom::Constants::Role::ADMIN)

    before(:create, &:generate_authentication_token!)

    before(:create) do |user|
      new_assignments = []
      Array(user.role_id).each { |role_id| new_assignments << { role_id: role_id } }
      user.role_assignments_attributes = new_assignments
    end
  end

  trait :admin_user do |_f|
    role_id TestMethods.find_or_create_role(Custom::Constants::Role::ADMIN)
  end

  trait :mentor_user do |_f|
    association :profile
    role_id TestMethods.find_or_create_role(Custom::Constants::Role::MENTOR)
  end

  trait :organization_user do |_f|
    association :organization
    role_id TestMethods.find_or_create_role(Custom::Constants::Role::ORGANIZATION)
  end
end
