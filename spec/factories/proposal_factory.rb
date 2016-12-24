FactoryGirl.define do
  factory :proposal do
    email { Faker::Internet.email }
    description 'MyText'
    status Proposal::PENDING

    after(:create, &:generate_invitation_token!)
  end
end
