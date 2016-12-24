FactoryGirl.define do
  factory :context do
    association :profile
    association :organization
    description 'MyText'
  end
end
