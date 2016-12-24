FactoryGirl.define do
  factory :role do
    slug { Faker::Lorem.word }
  end
end
