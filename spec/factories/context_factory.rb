FactoryGirl.define do
  factory :context do
    association :mentor
    association :organization
    description 'MyText'
  end
end
