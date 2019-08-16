FactoryBot.define do
  factory :movement do
    amount { 100 }
    datetime { '2019-01-01' }
    association :user
  end
end
