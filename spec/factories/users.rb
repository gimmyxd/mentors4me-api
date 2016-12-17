FactoryGirl.define do
  factory :user do
    association :profile
    association :organization
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    role User::ADMIN

    after(:create, &:generate_authentication_token!)
  end

  trait :admin do |f|
    f.user_role User::ADMIN
  end

  trait :mentor do |f|
    f.user_role User::MENTOR
    after(:create) { |user| create(:profile, user: user) }
  end

  trait :organization do |f|
    f.user_role User::NORMAL
    after(:create) { |user| create(:organization, user: user) }
  end
end
