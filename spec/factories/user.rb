FactoryBot.define do
  factory :user do
    sequence(:name)    { |n| "test_user_#{n}"}
    date_of_birth { 20.year.ago }

    association :country
  end
end
