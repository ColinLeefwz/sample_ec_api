require 'faker'

FactoryBot.define do
  factory :product do
    name { Faker::Name.unique.name }
    brand { Faker::Company.name }
    price { Faker::Number.number(digits: 5) }
    stock { Faker::Number.number(digits: 2) }
  end
end
