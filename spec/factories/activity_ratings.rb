FactoryBot.define do
  factory :activity_rating do
    activity_id { 1 }
    user_id { 1 }
    score { 1 }
    note { "MyString" }
  end
end
