FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    role User::ADMIN

    before(:create, &:generate_authentication_token!)
  end

  trait :admin do |_f|
    role User::ADMIN
  end

  trait :mentor do |_f|
    association :profile
    role User::MENTOR
    after(:create) { |user| create(:profile, user: user) }
  end

  trait :organization do |_f|
    association :organization
    role User::NORMAL
    after(:create) { |user| create(:organization, user: user) }
  end
end
