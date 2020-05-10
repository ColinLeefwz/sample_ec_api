FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { Faker::Internet.password(min_length: 6, max_length: 12, mix_case: false) }
    role { :customer }

    trait :admin do
      role { :admin }
    end
  end
end
