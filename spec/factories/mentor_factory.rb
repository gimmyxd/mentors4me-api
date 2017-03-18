# frozen_string_literal: true
FactoryGirl.define do
  factory :mentor do
    first_name { Faker::Name.name }
    last_name { Faker::Name.name }
    phone_number { Faker::PhoneNumber.cell_phone }
    city { Faker::Address.city }
    description 'some description'
    before(:create) do |mentor|
      mentor.skills = FactoryGirl.create_list(:skill, 4)
    end
  end
end
