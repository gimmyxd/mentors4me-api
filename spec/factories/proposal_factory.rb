# frozen_string_literal: true
FactoryGirl.define do
  factory :proposal do
    proposer_first_name { Faker::Name.name }
    proposer_last_name { Faker::Name.name }
    proposer_email { Faker::Internet.email }
    proposer_phone_number { Faker::PhoneNumber.cell_phone }
    mentor_first_name { Faker::Name.name }
    mentor_last_name { Faker::Name.name }
    mentor_organization { Faker::Name.name }
    mentor_email { Faker::Internet.email }
    mentor_phone_number { Faker::PhoneNumber.cell_phone }
    mentor_facebook 'www.facebook.com'
    mentor_linkedin 'www.linkedin.com'
    reason 'MyText'
    status Custom::Constants::Proposal::PENDING

    after(:create, &:generate_authentication_token!)
  end
end
