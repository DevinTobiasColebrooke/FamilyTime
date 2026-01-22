FactoryBot.define do
  factory :user do
    name { "MyString" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
