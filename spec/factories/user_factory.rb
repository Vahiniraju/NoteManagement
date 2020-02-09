FactoryBot.define do
  factory :user do
    first_name { 'First Name' }
    last_name { 'Last Name' }
    sequence(:email) { |n| "test#{n}@org.com" }
    password { 'srandomdf' }
    password_confirmation { 'srandomdf' }
    active { true }
  end
end
