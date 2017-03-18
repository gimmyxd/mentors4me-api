# frozen_string_literal: true
FactoryGirl.define do
  factory :organization do
    name { Faker::Company.name }
    asignee { Faker::Name.name }
    phone_number { Faker::PhoneNumber.cell_phone }
    city Faker::Address.city
    facebook 'www.facebook.com/organization'
    description 'some description'
  end
end
