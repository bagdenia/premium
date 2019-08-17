FactoryBot.define do
  factory :balance do
    balance { 100 }
    association :user
    association :movement
  end
end
