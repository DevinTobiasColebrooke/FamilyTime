FactoryBot.define do
  factory :event do
    type { "Event" }
    title { "MyString" }
    description { "MyText" }
    start_time { "2026-01-21 18:54:59" }
    end_time { "2026-01-21 18:54:59" }
    status { 1 }

    factory :meal, class: 'Meal' do
      type { 'Meal' }
    end

    factory :activity, class: 'Activity' do
      type { 'Activity' }
    end
  end
end
