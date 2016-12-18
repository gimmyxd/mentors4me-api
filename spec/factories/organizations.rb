FactoryGirl.define do
  factory :organization do
    name Faker::Company.name
    asignee Faker::Name.name
    phone_number Faker::PhoneNumber.cell_phone
    city Faker::Address.city
    description 'some description'
  end
end
