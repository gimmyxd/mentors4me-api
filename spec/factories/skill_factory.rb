# frozen_string_literal: true
FactoryGirl.define do
  factory :skill do
    name { Faker::Name.name }
  end
end
