FactoryBot.define do
  factory :user do
    surname { 'Иванов' }
    name { 'Иван' }
    patronymic { 'Иванович' }
    sequence(:email) { |n| "user#{n}@example.com" }
    age { 25 }
    nationality { 'Russian' }
    country { 'Russia' }
    gender { 'male' }
  end
end