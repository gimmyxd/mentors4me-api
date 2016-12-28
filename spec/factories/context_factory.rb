FactoryGirl.define do
  factory :context do
    description { Faker::Lorem.paragraph }
    before(:create) do |c|
      c.mentor = FactoryGirl.create(:user, :mentor_user)
      c.organization = FactoryGirl.create(:user, :organization_user)
    end
  end
end
