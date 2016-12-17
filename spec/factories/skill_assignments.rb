FactoryGirl.define do
  factory :skill_assignment do
    association :skill
    association :profile
    after(:create) { |skill_assignment| create(:skill, skill_assignment: skill_assignment) }
    after(:create) { |skill_assignment| create(:profile, skill_assignment: skill_assignment) }
  end
end
