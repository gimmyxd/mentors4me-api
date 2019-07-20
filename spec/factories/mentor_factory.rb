# frozen_string_literal: true
FactoryBot.define do
  factory :mentor do
    first_name { Faker::Name.name }
    last_name { Faker::Name.name }
    phone_number { Faker::PhoneNumber.cell_phone }
    city { Faker::Address.city }
    organization { 'Organization' }
    position { 'something' }
    occupation { 'occupation' }
    availability { 1.5 }
    description { 'some description' }
    before(:create) do |mentor|
      mentor.skills = FactoryBot.create_list(:skill, 4)
    end
  end
end
