FactoryGirl.define do
  factory :proposal do
    email { Faker::Internet.email }
    description 'MyText'
    status Custom::Constants::Proposal::PENDING

    after(:create, &:generate_authentication_token!)
  end
end
