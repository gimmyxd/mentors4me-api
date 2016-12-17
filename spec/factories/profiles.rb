FactoryGirl.define do
  factory :profile do
   first_name Faker::Name.name
   last_name Faker::Name.name
   phone_number Faker::PhoneNumber.cell_phone
   city Faker::Address.city
   description 'some description'
  end
end
