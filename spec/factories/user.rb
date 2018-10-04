FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    cell_phone { Faker::PhoneNumber.cell_phone }
    minimun_score { Faker::Number.decimal(1, 2) }
    password '123456'
    password_confirmation '123456'
  end
end