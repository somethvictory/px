FactoryBot.define do
  factory :transaction do
    association :user
    association :country
    amount_spent { 20 }
  end
end
