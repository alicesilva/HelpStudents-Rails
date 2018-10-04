FactoryBot.define do
    factory :task do
      name { Faker::Name.name }
      description { Faker::Lorem.paragraph }
      start { Faker::Date.forward(0)}
      close { Faker::Date.forward(0)}
      course
    end
  end
