FactoryBot.define do
  factory :subscriber do
    sequence(:email) { |n| "subscriber#{n}@example.com" }
    sequence(:name) { |n| "Subscriber #{n}" }
    status { "active" }
  end
end 